# Synty In Godot

Import your Synty asset packs from Unity to Godot.

#### Tested On

- Unity: 2022.3.15f1
- Godot: 4.2

#### Tested With Packs

- Polygon Dungeon
- Polygon Fantasy Kingdom

## Import Procedure

Import Synty packs by following this process. The name of the Synty pack is your `[PACK_NAME]` (e.g. `PolygonFantasyKingdom`)

- Check pack-specific setup instructions below. Apply them as needed
- Create a new 3D Unity project (or load an existing suitable one)
- Import `FBX Exporter` package from the standard Unity registry
- Import your Synty pack from the standard Unity registry
- Copy the contents of this repository's `unity` directory to your Unity project
- In your Godot Project
    - Create `assets/Synty/[PACK_NAME]` directory, or similar. This is your **pack directory**.
    - Copy everything from this repository's `godot` directory to your Godot project
    - Create a `textures` directory in the **pack directory**.
    - Copy all of the Synty textures to your textures directory. 
        - Be sure to maintain directory structure
        - It's ok to copy the whole `Textures` directory from the Synty pack but be sure to change the case of `Textures` to `textures`. You'll also get all the unity meta files if you do this.
        - You don't need the unity `.meta` files, they will be ignored, so it's best to exclude them.
- In Unity, open the `[PACK_NAME] - Everything` scene
- If you zoom out enough you will see the mess of every static asset in the pack
- Right-click the `[PACK_NAME]` node and choose `Export to FBX...`
- Set the export path to your Godot project's **pack directory**.
- Set options:
    - Export Format: Binary
    - Include: Models Only
    - Object Position: World Absolute
    - Compatible Naming: Off
- Click Export
- Switch to your Godot project and wait (1-2 minutes) for the new FBX file to import
    - It will copy all of the textures from the Unity project to your Godot project with long uuid names. You'll be able to delete these later.
- Double-click the `[PACK_NAME].fbx` file in the FileSystem dock to open import settings (this will take several seconds)
- Set the post import script to the `import-[PACK_NAME].gd` script from this repository's godot directory
- Click Reimport
- This will take a couple of minutes. When it's done you will have
    - `materials` directory with every material from the Synty pack, using textures from your `textures` directory
    - `scenes` directory with a Godot scene for every static prefab from the Synty pack, with collision shapes where provided
- You can now delete the uuid-named textures and the `[PACK_NAME].fbx`.

### Characters

The characters must be imported one by one in order to get skeleton retargeting to work correctly.

> Note: I tried just renaming the skeleton bones and skin bindings. That works but the animations are still messed up. The Godot retargeting does a lot more and I'm not sure there's a way to apply it post import.

- In the Unity project, open the `[PACK_NAME] - Single Character` scene
- There is a node at the end of the scene tree called `All Characters`. Each character has been prepared here for export.
- For each of the characters:
    - Drag the character into the `[PACK_NAME]-SingleCharacter/Models/Characters` node.
    - Export the main node the same way you did for the static assets, so that you have an FBX file in your godot project
    - Drag the character back into `All Characters`
    - In the Godot project, wait for the FBX to import
        - Apply the `import-[PACK_NAME].gd` script the same as when importing the static assets
        - Also quick-load the `synty-bone-map.res` file as the BoneMap on the `Skeleton3D` found in the FBX (find the skeleton in the tree on the left pane)
        - Reimport
    - You will now have the character scene in the `scenes/Characters`. It has the Godot default humanoid skeleton
    - Test that the rigging is correct using the provided `anim_test.tscn`
        - Put the new character scene into the `anim_test` scene
        - Set the animation player root node to be the character
        - Play the `walk` animation in the animation player
        - The character should walk forward. If it doesn't, recheck that the bone map is applied.

After you've done this for each character, you can safely delete the FBX file and the uuid textures.

# Per-Pack Setup

Perform these manual steps for your pack *before* executing the full instructions.

### Polygon Dungeon

After importing the Synty pack into your Unity project, convert these 2 textures to png:
- `Misc/Dungeons_Crystal_Metallic.tif`
- `Misc/Dungeons_Texture_Ghosts.tif`

If you have ffmpeg, try `ffmpeg -i src.tif dest.png`

Open material `Misc/Dungeons_Texture_Ghost`. Notice that the albedo texture is a .tif. Change it to the new .png version.

Do the same for the 4 main dungeon materials, for the metallic texture.

# Preparing the Unity Scenes

### Everything Scenes

- Bring all the Prefabs (except FX, Preset candles, and characters) into the `Models` nodes, mirroring the pack structure.
- Add the `many-materials-plane`
    - Rename it to `__all_materials`
    - Add every material from the pack's `Materials` directory
    - Set the mesh renderer materials count the number of materials you added
    - Drag `__all_materials` into `Assets` directory, rename it to `__all_materials-[PACK_NAME]`
- Drag all the `Collision` prefabs into `Collision`
- Drag every convex mesh into the 3D viewport to create a mesh object for each
    - Reset the transforms so it's at origin
    - Be sure to expand each mesh before you drag it, and reparent when necessary
    - Place them under `Convex`
    - **NOTE**: Some meshes may have a generated name. Unity will warn (in the inspector) that the object should match the filename. Click `Fix Object Name` as many times as needed until the warning goes away.
- Search the scene tree for "Wheel"
    - Object names that **end** in "Wheel" or "Wheel_##" need to be changed to "Whiil" or "Whiil_##"
    - This prevents Godot from turning these into wheel physics objects
