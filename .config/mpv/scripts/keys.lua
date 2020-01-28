function video_downloader()
    vidurl = mp.get_property("path")
    os.execute('notify-send "downloading video" && youtube-dl -o "/home/$USER/media/vid/toffee/%(title)s-%(id)s.%(ext)s" "' .. vidurl .. '" 2>&1 > /home/$USER/.cache/mpv_dl_log && notify-send "finished downloading video" &')
end
function save_local_video()
    vid_path = mp.get_property("path")
    print(vid_path:gsub("'", "\\'"))
    os.execute('toffee_save_file.sh "' .. vid_path:gsub('"', '\\"') .. '"')
    mp.command('stop')
end
function remove_video()
    vid_path = mp.get_property("path")
    print(vid_path)
    os.execute('rm.sh "' .. vid_path:gsub('"', '\\"') .. '"')
    mp.command('stop')
end
function yank_path_to_clipboard()
    vid_path = mp.get_property("path")
    os.execute('echo "' .. vid_path:gsub('"', '\\"') .. '" | xclip -selection clipboard')
    os.execute('notify-send "' .. vid_path:gsub('"', '\\"') .. '"')
end
function just_loop()
    i = 1
    while (true)
    do
        print('loop ' .. tostring(i))
        i = i + 1
    end
end
mp.add_key_binding("d", "download_video", video_downloader)
mp.add_key_binding("s", "save_local_video", save_local_video)
mp.add_key_binding("x", "remove_video", remove_video)
mp.add_key_binding("y", "yank_path", yank_path_to_clipboard)
-- mp.add_key_binding("y", "loop", just_loop)
