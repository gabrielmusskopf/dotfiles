
vim.keymap.set('n', '<leader>d', function ()
    vim.cmd('Dashboard');
end)

vim.g.dashboard_preview_command = 'cat'
vim.g.dashboard_preview_pipeline = 'lolcat'
vim.g.dashboard_preview_file = '~/.config/banner/preview'
vim.g.dashboard_preview_file_height = 5
vim.g.dashboard_preview_file_width = 80

    --local status_ok, db = pcall(require, "dashboard")
--if not status_ok then
--    print('Dashboard not found')
--     return
--end
--
--
--local version = vim.version()
--local header = {
--    "            :h-                                  Nhy`               ",
--    "           -mh.                           h.    `Ndho               ",
--    "           hmh+                          oNm.   oNdhh               ",
--    "          `Nmhd`                        /NNmd  /NNhhd               ",
--    "          -NNhhy                      `hMNmmm`+NNdhhh               ",
--    "          .NNmhhs              ```....`..-:/./mNdhhh+               ",
--    "           mNNdhhh-     `.-::///+++////++//:--.`-/sd`               ",
--    "           oNNNdhhdo..://++//++++++/+++//++///++/-.`                ",
--    "      y.   `mNNNmhhhdy+/++++//+/////++//+++///++////-` `/oos:       ",
--    " .    Nmy:  :NNNNmhhhhdy+/++/+++///:.....--:////+++///:.`:s+        ",
--    " h-   dNmNmy oNNNNNdhhhhy:/+/+++/-         ---:/+++//++//.`         ",
--    " hd+` -NNNy`./dNNNNNhhhh+-://///    -+oo:`  ::-:+////++///:`        ",
--    " /Nmhs+oss-:++/dNNNmhho:--::///    /mmmmmo  ../-///++///////.       ",
--    "  oNNdhhhhhhhs//osso/:---:::///    /yyyyso  ..o+-//////////:/.      ",
--    "   /mNNNmdhhhh/://+///::://////     -:::- ..+sy+:////////::/:/.     ",
--    "     /hNNNdhhs--:/+++////++/////.      ..-/yhhs-/////////::/::/`    ",
--    "       .ooo+/-::::/+///////++++//-/ossyyhhhhs/:///////:::/::::/:    ",
--    "       -///:::::::////++///+++/////:/+ooo+/::///////.::://::---+`   ",
--    "       /////+//++++/////+////-..//////////::-:::--`.:///:---:::/:   ",
--    "       //+++//++++++////+++///::--                 .::::-------::   ",
--    "       :/++++///////////++++//////.                -:/:----::../-   ",
--    "       -/++++//++///+//////////////               .::::---:::-.+`   ",
--    "       `////////////////////////////:.            --::-----...-/    ",
--    "        -///://////////////////////::::-..      :-:-:-..-::.`.+`    ",
--    "         :/://///:///::://::://::::::/:::::::-:---::-.-....``/- -   ",
--    "           ::::://::://::::::::::::::----------..-:....`.../- -+oo/ ",
--    "            -/:::-:::::---://:-::-::::----::---.-.......`-/.      ``",
--    "           s-`::--:::------:////----:---.-:::...-.....`./:          ",
--    "          yMNy.`::-.--::..-dmmhhhs-..-.-.......`.....-/:`           ",
--    "         oMNNNh. `-::--...:NNNdhhh/.--.`..``.......:/-              ",
--    "        :dy+:`      .-::-..NNNhhd+``..`...````.-::-`                ",
--    "                        .-:mNdhh:.......--::::-`                    ",
--    "                           yNh/..------..`                          ",
--    "                                                                    ",
--    "N E O V I M - v " .. version.major .. "." .. version.minor,
--    "",
--}
--
