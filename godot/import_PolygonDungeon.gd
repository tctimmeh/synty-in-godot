@tool
extends "./import_synty.gd"


func _post_import(scene):
    config = SynyImportConfig.new()
    config.unusual_obj_roots = unusual_obj_roots
    config.material_dirs = material_dirs
    config.texture_map = texture_map

    import_pack(scene)

    return scene


var unusual_obj_roots = []


var material_dirs = {
    "Dungeon_Material_01": "",
    "Dungeon_Material_02": "",
    "Dungeon_Material_03": "",
    "Dungeon_Material_04": "",
    "Dungeons_Material_Characters_01": "",
    "Dungeon_Material_01_A": "Alternatives",
    "Dungeon_Material_01_B": "Alternatives",
    "Dungeon_Material_01_C": "Alternatives",
    "Dungeon_Material_01_D": "Alternatives",
    "Dungeon_Material_02_A": "Alternatives",
    "Dungeon_Material_02_B": "Alternatives",
    "Dungeon_Material_02_C": "Alternatives",
    "Dungeon_Material_02_D": "Alternatives",
    "Dungeon_Material_03_A": "Alternatives",
    "Dungeon_Material_03_B": "Alternatives",
    "Dungeon_Material_03_C": "Alternatives",
    "Dungeon_Material_03_D": "Alternatives",
    "Dungeon_Material_04_A": "Alternatives",
    "Dungeon_Material_04_B": "Alternatives",
    "Dungeon_Material_04_C": "Alternatives",
    "Dungeon_Material_04_D": "Alternatives",
    "Dungeon_Material_Ice": "Misc",
    "Dungeon_Material_Snow": "Misc",
    "Dungeon_Material_TextureFloor_09": "Misc",
    "Dungeon_Material_TextureFloor_10": "Misc",
    "Dungeon_Material_TextureFloor": "Misc",
    "Dungeon_Material_TextureWalls": "Misc",
    "Dungeon_Material_Transparent": "Misc",
    "Dungeons_Material_Dust_Soft": "Misc",
    "Dungeons_Material_Emmision": "Misc",
    "Dungeons_Material_Ghost_Soft": "Misc",
    "Dungeons_Material_Lava": "Misc",
    "Dungeons_Texture_Ghost": "Misc",
    "FX_CandleFlame": "Misc",
    "FX_Dirt": "Misc",
    "FX_Fog_Breakup": "Misc",
    "FX_Fog_Dark": "Misc",
    "FX_Fog_Light": "Misc",
    "FX_LightRay": "Misc",
    "FX_Standard": "Misc",
    "FX_Water": "Misc",
    "FX_Water_Sewer": "Misc",
}


var texture_map = {
    "Dungeons_Texture_01.png": "",
    "Dungeons_Texture_02.png": "",
    "Dungeons_Texture_03.png": "",
    "Dungeons_Texture_04.png": "",
    "Dungeons_Texture_01_A.png": "Alternatives",
    "Dungeons_Texture_01_B.png": "Alternatives",
    "Dungeons_Texture_01_C.png": "Alternatives",
    "Dungeons_Texture_01_D.png": "Alternatives",
    "Dungeons_Texture_02_A.png": "Alternatives",
    "Dungeons_Texture_02_B.png": "Alternatives",
    "Dungeons_Texture_02_C.png": "Alternatives",
    "Dungeons_Texture_02_D.png": "Alternatives",
    "Dungeons_Texture_03_A.png": "Alternatives",
    "Dungeons_Texture_03_B.png": "Alternatives",
    "Dungeons_Texture_03_C.png": "Alternatives",
    "Dungeons_Texture_03_D.png": "Alternatives",
    "Dungeons_Texture_04_A.png": "Alternatives",
    "Dungeons_Texture_04_B.png": "Alternatives",
    "Dungeons_Texture_04_C.png": "Alternatives",
    "Dungeons_Texture_04_D.png": "Alternatives",
    "Emmisive_01.png": "Emmisive",
    "Emmisive_02.png": "Emmisive",
    "Emmisive_03.png": "Emmisive",
    "Emmisive_04.png": "Emmisive",
    # "Dungeon_Fog_Breakup.tga": "Misc",
    # "Dungeons_Crystal_Metallic.tif": "Misc",
    "Dungeons_Texture_FloorTiles_01.png": "Misc",
    "Dungeons_Texture_FloorTiles_02.png": "Misc",
    "Dungeons_Texture_FloorTiles_03.png": "Misc",
    "Dungeons_Texture_FloorTiles_04.png": "Misc",
    "Dungeons_Texture_FloorTiles_mask.png": "Misc",
    "Dungeons_Texture_FloorTiles_Normal.png": "Misc",
    # "Dungeons_Texture_Ghosts.tif": "Misc",
    "Dungeons_Texture_Ghosts.png": "Misc",
    "Dungeons_Texture_Soft_Particle.png": "Misc",
    "Dungeons_Texture_WallTiles_01.png": "Misc",
    "Dungeons_Texture_WallTiles_02.png": "Misc",
    "Dungeons_Texture_WallTiles_03.png": "Misc",
    "Dungeons_Texture_WallTiles_04.png": "Misc",
    "Dungeons_Texture_WallTiles_mask.png": "Misc",
    "Dungeons_Texture_WallTiles_Normal.png": "Misc",
    "Dungeons_Texture_FloorTile_09_01.png": "Misc/ExtraTiles",
    "Dungeons_Texture_FloorTile_09_02.png": "Misc/ExtraTiles",
    "Dungeons_Texture_FloorTile_09_03.png": "Misc/ExtraTiles",
    "Dungeons_Texture_FloorTile_09_04.png": "Misc/ExtraTiles",
    "Dungeons_Texture_FloorTile_09_normals.png": "Misc/ExtraTiles",
    "Dungeons_Texture_FloorTile_10_01.png": "Misc/ExtraTiles",
    "Dungeons_Texture_FloorTile_10_02.png": "Misc/ExtraTiles",
    "Dungeons_Texture_FloorTile_10_03.png": "Misc/ExtraTiles",
    "Dungeons_Texture_FloorTile_10_04.png": "Misc/ExtraTiles",
    "Dungeons_Texture_FloorTile_10_normals.png": "Misc/ExtraTiles",
}
