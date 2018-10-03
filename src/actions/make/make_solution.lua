--
-- make_solution.lua
-- Generate a solution-level makefile.
-- Copyright (c) 2002-2009 Jason Perkins and the Premake project
--

	function premake.make_solution(sln)
		-- create a shortcut to the compiler interface
		local cc = premake[_OPTIONS.cc]

		-- build a list of supported target platforms that also includes a generic build
		local platforms = premake.filterplatforms(sln, cc.platforms, "Native")

		-- write a header showing the build options
		_p('# %s solution makefile autogenerated by GENie', premake.action.current().shortname)
		_p('# Type "make help" for usage help')
		_p('')

		-- set a default configuration
		_p('ifndef config')
		_p('  config=%s', _MAKE.esc(premake.getconfigname(sln.configurations[1], platforms[1], true)))
		_p('endif')
		_p('export config')
		_p('')

		local projects = table.extract(sln.projects, "name")
		table.sort(projects)

		-- list the projects included in the solution
		_p('PROJECTS := %s', table.concat(_MAKE.esc(projects), " "))
		_p('')
		_p('.PHONY: all clean help $(PROJECTS)')
		_p('')
		_p('all: $(PROJECTS)')
		_p('')

		-- write the project build rules
		for _, prj in ipairs(sln.projects) do
			_p('%s: %s', _MAKE.esc(prj.name), table.concat(_MAKE.esc(table.extract(premake.getdependencies(prj), "name")), " "))
			if (not sln.messageskip) or (not table.contains(sln.messageskip, "SkipBuildingMessage")) then
				_p('\t@echo "==== Building %s ($(config)) ===="', prj.name)
			end
			_p('\t@${MAKE} --no-print-directory -C %s -f %s', _MAKE.esc(path.getrelative(sln.location, prj.location)), _MAKE.esc(_MAKE.getmakefilename(prj, true)))
			_p('')
		end

		-- clean rules
		_p('clean:')
		for _ ,prj in ipairs(sln.projects) do
			_p('\t@${MAKE} --no-print-directory -C %s -f %s clean', _MAKE.esc(path.getrelative(sln.location, prj.location)), _MAKE.esc(_MAKE.getmakefilename(prj, true)))
		end
		_p('')

		-- help rule
		_p('help:')
		_p(1,'@echo "Usage: make [config=name] [target]"')
		_p(1,'@echo ""')
		_p(1,'@echo "CONFIGURATIONS:"')

		local cfgpairs = { }
		for _, platform in ipairs(platforms) do
			for _, cfgname in ipairs(sln.configurations) do
				_p(1,'@echo "   %s"', premake.getconfigname(cfgname, platform, true))
			end
		end

		_p(1,'@echo ""')
		_p(1,'@echo "TARGETS:"')
		_p(1,'@echo "   all (default)"')
		_p(1,'@echo "   clean"')

		for _, prj in ipairs(sln.projects) do
			_p(1,'@echo "   %s"', prj.name)
		end

		_p(1,'@echo ""')
		_p(1,'@echo "For more information, see https://github.com/bkaradzic/genie"')

	end
