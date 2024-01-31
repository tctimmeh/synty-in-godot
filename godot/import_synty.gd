@tool
extends EditorScenePostImport

class SynyImportConfig extends Object:
    var unusual_obj_roots: Array
    var material_dirs: Dictionary
    var texture_map: Dictionary

var config: SynyImportConfig
var scene_path: String
var materials_path: String
var textures_path: String

var collision_node: Node3D
var convex_node: Node3D

var current_path := []

var rx_obj_name := RegEx.create_from_string("SM_(?<category>(?:Chr_Attach)|(?:.*?))_(?<name>.*)")
var rx_under_digits := RegEx.create_from_string("_\\d+")
var rx_texture_file := RegEx.create_from_string(".*?-\\w+?_(?<filename>.*)")

var materials := {}

func import_pack(scene):
    var pack_root_path = get_source_file().get_base_dir()
    scene_path = "/".join([pack_root_path, "scenes"])
    materials_path = "/".join([pack_root_path, "materials"])
    textures_path = "/".join([pack_root_path, "textures"])
    ensure_path(scene_path)

    var root_node = scene.get_node("RootNode")
    var pack_node = root_node.get_child(0)
    var models_node = pack_node.get_node("Models")
    collision_node = pack_node.get_node("Collision")
    convex_node = pack_node.get_node("Convex")

    var all_materials_node = pack_node.get_node_or_null("__all_materials")
    if all_materials_node:
        fix_materials(all_materials_node)

    for child in models_node.get_children():
        load_models(child)

    return scene


func load_models(model_root):
    if model_root is MeshInstance3D or model_root.name in config.unusual_obj_roots:
        create_scene(model_root)
        return
    if model_root is Skeleton3D:
        var d = current_path.pop_back() # I'm a bad person
        create_scene(model_root, true)
        current_path.push_back(d) # really bad
        return

    current_path.push_back(model_root.name)
    for child in model_root.get_children():
        load_models(child)
    current_path.pop_back()
    

func create_scene(import_root, use_parent_name=false):
    fix_wheels(import_root)
    var obj_name = import_root.name
    if use_parent_name:
        obj_name = import_root.get_parent().name

    var name_match = rx_obj_name.search(obj_name)
    if not name_match:
        printerr(obj_name, "(", current_path_str(), "):", "Invalid Name - does not match rx_obj_name")
        return

    var category = name_match.get_string("category")
    var short_name = name_match.get_string("name")
    var scene_name = short_name

    var save_dir = [scene_path] + current_path
    ensure_path("/".join(save_dir))
    var save_path = "/".join(save_dir + [scene_name + ".tscn"])

    fix_materials(import_root)
    if import_root is Skeleton3D and category == "Chr":
        var submesh = import_root.get_node_or_null("%s_1" % import_root.get_parent().name)
        if submesh:
            submesh.name = import_root.get_parent().name
        
        # fix_skeleton(import_root)
        # fix_skins(import_root)

    var colliders = find_colliders(import_root)
    var collider
    if len(colliders):
        collider = colliders[-1]
        if len(colliders) > 1:
            print_rich("[color=yellow]", obj_name, "[/color] has [color=orange]", len(colliders), " colliders[/color]")
    # else:
    #     print_rich("[color=yellow]", obj_name, "[/color] has [color=yellow]NO colliders[/color]")

    var scene_root
    if collider:
        scene_root = StaticBody3D.new()
    else:
        scene_root = Node3D.new()

    scene_root.name = scene_name
    scene_root.set_meta("category", category)
    scene_root.add_child(import_root.duplicate())

    if collider:
        add_colliders(scene_root, collider[0], collider[1])

    set_owner_recursive(scene_root, scene_root)
    var packed_scene := PackedScene.new()
    packed_scene.pack(scene_root)
    ResourceSaver.save(packed_scene, save_path)


func find_colliders(obj_root):
    var obj_name = obj_root.name
    var colliders := []

    var collision_name = "%s_Collision" % obj_name
    for node in collision_node.get_children():
        if node.name.find(collision_name) != 0:
            continue
        colliders.append([node, false])
        
    var convex_name = "%s_Convex" % obj_name
    for node in convex_node.get_children():
        if node.name.find(convex_name) != 0:
            continue
        colliders.append([node, true])
        
    return colliders


func add_colliders(scene_root, collider, is_convex):
    if not collider is MeshInstance3D:
        printerr(scene_root.name, " cannot be used as a collider - not a mesh instance")
        return
    
    var collision_shape = CollisionShape3D.new()
    if is_convex:
        collision_shape.shape = collider.mesh.create_convex_shape(false, false)
    else:
        collision_shape.shape = collider.mesh.create_trimesh_shape()

    scene_root.add_child(collision_shape)

    for child_collider in collider.get_children():
        add_colliders(scene_root, child_collider, is_convex)


func fix_materials(obj_root):
    if obj_root is MeshInstance3D:
        var mesh = obj_root.mesh
        for i in range(mesh.get_surface_count()):
            var mat = mesh["surface_%d/material" % i]
            var mat_name = mesh["surface_%d/name" % i]

            var existing_mat = materials.get(mat_name)
            if not existing_mat:
                if not config.material_dirs.has(mat_name):
                    printerr("Unknown directory for material: %s" % mat_name)
                    fix_textures(mat)
                    continue

                var save_dir = materials_path
                if config.material_dirs.has(mat_name):
                    save_dir += "/%s" % config.material_dirs[mat_name]
                ensure_path(save_dir)
                var save_file = "/".join([save_dir, "%s.res" % mat_name])
                if FileAccess.file_exists(save_file):
                    existing_mat = load(save_file)
                else:
                    mat = mat.duplicate()
                    mat.vertex_color_use_as_albedo = false
                    fix_textures(mat)
                    mat.resource_path = save_file
                    ResourceSaver.save(mat)
                    existing_mat = mat

                materials[mat_name] = existing_mat

            mesh["surface_%d/material" % i] = existing_mat

    for child in obj_root.get_children():
        fix_materials(child)


func fix_textures(material):
    for i in range(BaseMaterial3D.TEXTURE_MAX):
        var imported_texture = material.get_texture(i)
        if not imported_texture:
            continue
        var imported_filename = imported_texture.resource_path.get_file()
        var tex_name_match = rx_texture_file.search(imported_filename)
        if not tex_name_match:
            printerr("Texture name mismatch: %s" % imported_filename)
            continue
        
        var filename = tex_name_match.get_string("filename")
        if filename.ends_with(".tif"):
            prints("ME ->", filename, filename.replace(".tif", ".png"))
            filename = filename.replace(".tif", ".png")
        var texture_subdir = config.texture_map.get(filename)
        if texture_subdir == null:
            printerr("No mapping for texture: %s" % filename)
            continue
        var texture_filename = "/".join([textures_path, texture_subdir, filename])
        var existing_texture = load(texture_filename)
        if not existing_texture:
            printerr("Missing Texture: %s" % texture_filename)
            continue

        material.set_texture(i, existing_texture)


func fix_wheels(node):
    # godot will turn the "wheels" into actual wheel objects. to avoid this they've been renamed to "whiil" in the unity project. turn them back into wheels now
    node.name = node.name.replacen("whiil", "Wheel")
    for child in node.get_children():
        fix_wheels(child)


func set_owner_recursive(node, owner):
    if node != owner:
        node.owner = owner

    for child in node.get_children():
        set_owner_recursive(child, owner)


func ensure_path(path):
    if DirAccess.dir_exists_absolute(path):
        return
    DirAccess.make_dir_recursive_absolute(path)


func current_path_str():
    return "/".join(current_path)


# func fix_skeleton(skeleton: Skeleton3D):
#     skeleton.name = "GeneralSkeleton"
#     for bone_idx in range(skeleton.get_bone_count()):
#         var old_name = skeleton.get_bone_name(bone_idx)
#         var new_name = get_replacement_bone(old_name)
#         skeleton.set_bone_name(bone_idx, new_name)


# func fix_skins(node):
#     for child in node.get_children():
#         fix_skins(child)
#     if not node is MeshInstance3D:
#         return
#     if not node.skin:
#         return
    
#     var skin = node.skin
#     for i in range(skin.get_bind_count()):
#         var old_name = skin.get_bind_name(i)
#         var new_name = get_replacement_bone(old_name)
#         skin.set_bind_name(i, new_name)


# func trim_bone_numbers(name: String):
#     var digit_matches = rx_under_digits.search_all(name)
#     if not digit_matches:
#         return name
#     if not " " in name and ( \
#         name.find("Spine") == 0 or \
#         name.find("Finger") == 0 or \
#         name.find("IndexFinger") == 0 or \
#         name.find("Thumb") == 0 \
#     ):
#         # these bone names NORMALLY end with digits. don't trim if there's only 1 set
#         if len(digit_matches) == 1:
#             return name

#     var digits_start = digit_matches[-1].get_start()
#     var digits_end = digit_matches[-1].get_end()
#     if digits_end < name.length():
#         return name
    
#     var new_name = name.substr(0, digits_start)
#     if not new_name in bone_map:
#         return name
#     return new_name


# func get_replacement_bone(old_name: String):
#     var search_name = trim_bone_numbers(old_name)
#     var new_name = bone_map.get(search_name)
#     if not new_name:
#         return old_name
#     return new_name


# const bone_map = {
#     "Root": "Root",
#     "Hips": "Hips",
#     "Spine_01": "Spine",
#     "Spine_02": "Chest",
#     "Spine_03": "UpperChest",
#     "Neck": "Neck",
#     "Head": "Head",
#     "Eyebrows": "Eyebrows",
#     "Eyes": "Eyes",
#     # "": "LeftEye",
#     # "": "RightEye",
#     "Jaw": "Jaw",
#     "Clavicle_L": "LeftShoulder",
#     "Shoulder_L": "LeftUpperArm",
#     "Elbow_L": "LeftLowerArm",
#     "Hand_L": "LeftHand",
#     "Thumb_01": "LeftThumbMetacarpal",
#     "Thumb_02": "LeftThumbProximal",
#     "Thumb_03": "LeftThumbDistal",
#     "IndexFinger_01": "LeftIndexProximal",
#     "IndexFinger_02": "LeftIndexIntermediate",
#     "IndexFinger_03": "LeftIndexDistal",
#     "IndexFinger_04": "IndexFinger_04",
#     # "": "LeftMiddleProximal",
#     # "": "LeftMiddleIntermediate",
#     # "": "LeftMiddleDistal",
#     "Finger_01": "LeftRingProximal",
#     "Finger_02": "LeftRingIntermediate",
#     "Finger_03": "LeftRingDistal",
#     "Finger_04": "Finger_04",
#     # "": "LeftLittleProximal",
#     # "": "LeftLittleIntermediate",
#     # "": "LeftLittleDistal",
#     "Clavicle_R": "RightShoulder",
#     "Shoulder_R": "RightUpperArm",
#     "Elbow_R": "RightLowerArm",
#     "Hand_R": "RightHand",
#     "Thumb_01 1": "RightThumbMetacarpal",
#     "Thumb_02 1": "RightThumbProximal",
#     "Thumb_03 1": "RightThumbDistal",
#     "IndexFinger_01 1": "RightIndexProximal",
#     "IndexFinger_02 1": "RightIndexIntermediate",
#     "IndexFinger_03 1": "RightIndexDistal",
#     "IndexFinger_04 1": "IndexFinger04 1",
#     # "": "RightMiddleProximal",
#     # "": "RightMiddleIntermediate",
#     # "": "RightMiddleDistal",
#     "Finger_01 1": "RightRingProximal",
#     "Finger_02 1": "RightRingIntermediate",
#     "Finger_03 1": "RightRingDistal",
#     "Finger_04 1": "Finger_04 1",
#     # "": "RightLittleProximal",
#     # "": "RightLittleIntermediate",
#     # "": "RightLittleDistal",
#     "UpperLeg_L": "LeftUpperLeg",
#     "LowerLeg_L": "LeftLowerLeg",
#     "Ankle_L": "LeftFoot",
#     "Ball_L": "LeftToes",
#     "Toes_L": "Toes_L",
#     "UpperLeg_R": "RightUpperLeg",
#     "LowerLeg_R": "RightLowerLeg",
#     "Ankle_R": "RightFoot",
#     "Ball_R": "RightToes",
#     "Toes_R": "Toes_R",
# }
