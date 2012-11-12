#
#
#
class RPG::EventCommand
  module EvCCodes
    # // VX
    SHOW_TEXT              = 101
    SHOW_TEXT_LINE         = 401
    SHOW_CHOICE            = 102
    SHOW_CHOICE_BRANCH     = 402
    SHOW_CHOICE_CANCEL     = 403
    SHOW_CHOICE_END        = 404
    INPUT_NUMBER           = 103
    COMMENT_START          = 108
    COMMENT_LINE           = 408
    CONDITIONAL_BRANCH     = 111
    ELSE                   = 411
    LOOP                   = 112
    REPEAT_ABOVE           = 413
    BREAK_LOOP             = 113
    EXIT_EVENT_PROCCESS    = 115
    CALL_COMMON_EVENT      = 117
    LABEL                  = 118
    JUMP_TO_LABEL          = 119
    CONTROL_SWITCH         = 121 
    CONTROL_VARIABLE       = 122
    CONTROL_SELF_SWITCH    = 123
    CONTROL_TIMER          = 124
    CHANGE_GOLD            = 125
    CHANGE_ITEMS           = 126
    CHANGE_WEAPON          = 127
    CHANGE_ARMOR           = 128
    CHANGE_PARTY_MEMBER    = 129
    CHANGE_BATTLE_BGM      = 132
    CHANGE_BATTLE_ME       = 133
    CHANGE_SAVE_ACCESS     = 134
    CHANGE_MENU_ACCESS     = 135
    CHANGE_ENCOUNTER       = 136
    TRANSFER_PLAYER        = 201
    SET_VEHICLE_LOCATION   = 202
    SET_EVENT_LOCATION     = 203
    SCROLL_MAP             = 204
    SET_MOVE_ROUTE         = 205
    MOVE_COMMAND           = 505
    GET_ON_OFF_VEHICLE     = 206
    CHANGE_TRANSPERENCY    = 211
    SHOW_ANIMATION         = 212
    SHOW_BALLOON           = 213
    ERASE_EVENT            = 214
    FADEOUT_SCREEN         = 221
    FADEIN_SCREEN          = 222
    TINT_SCREEN            = 223
    FLASH_SCREEN           = 224
    SHAKE_SCREEN           = 225
    WAIT                   = 230
    SHOW_PICTURE           = 231
    MOVE_PICTURE           = 232
    ROTATE_PICTURE         = 233
    TINT_PICTURE           = 234
    ERASE_PICTURE          = 235
    SET_WEATHER_EFFECTS    = 236
    PLAY_BGM               = 241
    FADEOUT_BGM            = 242
    PLAY_BGS               = 245
    FADEOUT_BGS            = 246
    PLAY_ME                = 249 
    PLAY_SE                = 250
    STOP_SE                = 251
    BATTLE_PROCESS         = 301
    IF_WIN                 = 601
    IF_ESCAPE              = 602
    IF_LOSE                = 603
    SHOP_PROCESS           = 302
    NAME_INPUT_PROCESS     = 303
    CHANGE_HP              = 311
    CHANGE_MP              = 312
    CHANGE_STATE           = 313
    RECOVER_ALL            = 314
    CHANGE_EXP             = 315
    CHANGE_LEVEL           = 316
    CHANGE_PARAMS          = 317
    CHANGE_SKILLS          = 318
    CHANGE_EQUIP           = 319
    CHANGE_NAME            = 320
    CHANGE_CLASS           = 321
    CHANGE_ACTOR_GRAPHIC   = 322
    CHANGE_VEHICLE_GRAPHIC = 323
    CHANGE_ENEMY_HP        = 331
    CHANGE_ENEMY_MP        = 332
    CHANGE_ENEMY_STATE     = 333
    ENEMY_RECOVER_ALL      = 334
    ENEMY_APPEAR           = 335
    ENEMY_TRANSFORM        = 336
    SHOW_BATTLE_ANIMATION  = 337
    FORCE_ACTION           = 339
    ABORT_BATTLE           = 340
    OPEN_MENU_SCREEN       = 351
    OPEN_SAVE_SCREEN       = 352
    GAMEOVER               = 353
    RETURN_TO_TITLE_SCREEN = 354 
    SCRIPT                 = 355
    # // VX-Ace
    SHOW_ITEM_SELECTION    = 104
    SHOW_SCROLLING_TEXT    = 105
    CHANGE_FORMATION_ACCESS= 137
    CHANGE_WINDOW_TONE     = 138
    FOLLOWERS_VISIBLE      = 216
    FOLLOWERS_GATHER       = 217
    SAVE_BGM               = 243
    REPLAY_BGM             = 244
    PLAY_MOVIE             = 261
    CHANGE_MAP_NAME_DISPLAY= 281
    CHANGE_TILESET         = 282
    CHANGE_BATTLEBACK      = 283
    CHANGE_PARALLAX        = 284
    GET_POSITION_INFO      = 285
    CHANGE_NICKNAME        = 324
    # // Code Sets
    COMMENT_CODES   = [COMMENT_START, COMMENT_LINE]
    TEXT_CODES      = [SHOW_TEXT, SHOW_TEXT_LINE]
    CONDITION_CODES = [CONDITIONAL_BRANCH, ELSE]
  end
  include EvCCodes
end  