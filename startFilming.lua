local log = hs.logger.new('StartFilming', 'debug')

filmingTask = false


function StartFilming()
	filmingTask = true

	-- film
	-- ffmpeg -video_size 1280x720 -framerate 30 -f avfoundation -i "default" ~/Downloads/out.mpg

	hs.timer.doAfter(0.2, function()
		hs.execute('rm mugshots/movie.mpg')
		hs.execute('open film.command')
		hs.timer.doAfter(0.5, function()
			local app = hs.application.frontmostApplication():hide()
		end)
	end)
end