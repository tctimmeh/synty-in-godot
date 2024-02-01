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
    "DefaultMaterial": "",
    "Default-Material": "",
    "PolygonDungeonRealms_Mat_01_A": "",
    "PolygonDungeonRealms_Mat_02_A": "",
    "PolygonDungeonRealms_Mat_03_A": "",
    "PolygonDungeonRealms_Mat_04_A": "",
    "PolygonDungeonRealms_Mat_01_B": "Alternates",
    "PolygonDungeonRealms_Mat_01_C": "Alternates",
    "PolygonDungeonRealms_Mat_02_B": "Alternates",
    "PolygonDungeonRealms_Mat_02_C": "Alternates",
    "PolygonDungeonRealms_Mat_03_B": "Alternates",
    "PolygonDungeonRealms_Mat_03_C": "Alternates",
    "PolygonDungeonRealms_Mat_04_B": "Alternates",
    "PolygonDungeonRealms_Mat_04_C": "Alternates",
    "Cloud": "Misc",
    "Dust": "Misc",
    "FX_Circle_Mat": "Misc",
    "FX_Circle_Soft_Mat": "Misc",
    "FX_Portal_Dark": "Misc",
    "FX_Portal_Mat 1": "Misc",
    "FX_Portal_Mat": "Misc",
    "FX_Standard 1": "Misc",
    "FX_Standard_Soft": "Misc",
    "FX_SunBeam": "Misc",
    "GOLD_Coins": "Misc",
    "GOLD": "Misc",
    "Gold_Sparkle_Mat": "Misc",
    "Lava": "Misc",
    "PolygonDungeonRealms_Crystal_01": "Misc",
    "PolygonDungeonRealms_Crystal_02": "Misc",
    "PolygonDungeonRealms_Crystal_03": "Misc",
    "SimpleSky_Mat": "Misc",
    "SpiderWeb": "Misc",
}


var texture_map = {
    "Dungeons_2_Texture_01_A.png": "",
    "Dungeons_2_Texture_01_B.png": "",
    "Dungeons_2_Texture_01_C.png": "",
    "Dungeons_2_Texture_02_A.png": "",
    "Dungeons_2_Texture_02_B.png": "",
    "Dungeons_2_Texture_02_C.png": "",
    "Dungeons_2_Texture_03_A.png": "",
    "Dungeons_2_Texture_03_B.png": "",
    "Dungeons_2_Texture_03_C.png": "",
    "Dungeons_2_Texture_04_A.png": "",
    "Dungeons_2_Texture_04_B.png": "",
    "Dungeons_2_Texture_04_C.png": "",
    "Dungeons_2_Texture_Emission_01.png": "Misc",
    "Dungeons_2_Texture_Emission_02.png": "Misc",
    "Dungeons_2_Texture_Emission_03.png": "Misc",
    "Dungeons_2_Texture_Emission_04.png": "Misc",
    "Dungeons_2_Texture_Normal_Map.png": "Misc",
    "Dungeons_Realms_Metallic.png": "Misc",
    "Dungeons_Realms_Metallic.tif": "Misc",
    "FX_Circle_Soft_Tex.png": "Misc",
    "FX_Circle_Tex.png": "Misc",
    "FX_Gold_Sparkle_Tex.png": "Misc",
    "FX_SunBeam_Tex.png": "Misc",
    "Gold_Diffuse.png": "Misc",
    "Gold_Normal.png": "Misc",
    "SimpleSky_Texture.png": "Misc",
    "Spiderweb_01.png": "Misc",
    "Spiderweb_01_25.png": "Misc",
}
