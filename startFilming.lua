local log = hs.logger.new('StartFilming', 'debug')

filmingTask = false


function StartFilming()
	filmingTask = true

	-- start med at filme :)

	hs.timer.doAfter(0.2, function()
		hs.execute('rm mugshots/movie.mpg')
		hs.execute('open film.command')
		hs.timer.doAfter(0.5, function()
			local app = hs.application.frontmostApplication():hide()
		end)
	end)
end