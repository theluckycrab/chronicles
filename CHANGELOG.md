# [Unreleased]

# [v1.0.0]

[Changed] .gitignore no longer includex export_presets
[Fixed] BaseItem and BaseAbility were not cleaned up properly during mobile creation
[Changed] emote state now defaults to held
[Fixed] idle now transitions to fall
[Added] chat commands, emote and skyboost
[Fixed] interfaces now clean themselves up
[Added] config file now saves invert/fullscreen values
[Added] Data now has functions for reading config and saves
[Changed] disabled unused signal warning in Project > Debug > Gdscript
[Added] sm_controlled now counts "ui_opened" and "ui_closed" signals and locks input if != 0
[Added] server.send_chat(message: Dictionary)
[Added] chatbox that responds to Events signal "chat_message_received"
[Changed] moved sm_controlled's input handling into _unhandled_input()
[Changed] mobile's equip() function now expects an item's dictionary
[Added] base_item now includes a to_dict() function
[Changed] mobile's build process now has networked equip calls
[Added] equip function to mobile
[Changed] defined npc() and is_dummy() templates in i_networked.gd
[Added] mobile.move() now includes an npc() call to sync_move()
[Added] npc(), sync_move(), and is_dummy() added to mobile
[Fixed] wrong path for npc calls to find map
[Changed] test_room spawns dummies in place of other players
[Changed] armature_animator now uses relative path for root node
[Changed] mobile no longer loads a dictionary on ready
[Changed] client's join call moved to test_room.gd
[Changed] client connection and history retrieval restored
[Added] CHANGELOG.md

