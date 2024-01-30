# Synty Everything

Tested on:

Unity: 2022.3.15f1
Godot: 4.2

## Polygon Fantasy Kingdom

- In your Godot Project
    - Create `assets/Synty/PolygonFantasyKingdom` directory, or similar. This is your **pack directory**.
    - Copy everything from this repository's `godot` directory to your Godot project
    - Create a `textures` directory in the **pack directory**.
    - Copy all of the Synty textures to your textures directory. 
        - Be sure to maintain directory structure
        - It's ok to copy the whole `Textures` directory from the Synty pack but be sure to change the case of `Textures` to `textures`. You'll also get all the unity meta files if you do this.
        - You don't need the unity `.meta` files, they will be ignored, so it's best to exclude them.
- Create a new 3D Unity project (or load an existing suitable one)
- Import `FBX Exporter` package from the standard Unity registry
- Import `POLYGON Fantasy Kingdom` from the standard Unity registry
- Copy this repository's `[PACK_NAME]/unity/Assets` directory to your Unity project
- In Unity, open the `PolygonFantasyKingdom - Everything` scene
- If you zoom out enough you will see the mess of every static asset in the pack
- Right-click the `PolygonFantasyKingdom` node and choose `Export to FBX...`
- Set the export path to your Godot project's **pack directory**.
- Set options:
    - Export Format: Binary
    - Include: Models Only
    - Object Position: World Absolute
    - Compatible Naming: Off
- Click Export
- Switch to your Godot project and wait (1-2 minutes) for the new FBX file to import
    - It will copy all of the textures from the Unity project to your Godot project with long uuid names. You'll be able to delete these later.
- Double-click the `PolygonFantasyKingdom.fbx` file in the FileSystem dock to open import settings (this will take several seconds)
- Set the post import script to the `import-[PACK_NAME].gd` script from this repository's godot directory
- Click Reimport
- This will take a couple of minutes. When it's done you will have
    - `materials` directory with every material from the Synty pack, using textures from your `textures` directory
    - `scenes` directory with a Godot scene for every static prefab from the Synty pack, with collision shapes where provided
- You can now delete the uuid-named textures and the `PolygonFantasyKingdom.fbx`.

### Characters

The characters must be imported one by one in order to get skeleton retargeting to work correctly.

> Note: I tried just renaming the skeleton bones and skin bindings. That works but the animations are still messed up. The Godot retargeting does a lot more and I'm not sure there's a way to apply it post import.

- In the Unity project, open the `PolygonFantasyKingdom - Single Character` scene
- There is a node at the end of the scene tree called `All Characters`. Each character has been prepared here for export.
- For each of the characters:
    - Drag the character into the `PolygonFantasyKingdom-SingleCharacter/Models/Characters` node.
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
