local M = {}

-- Initialize tracking data
M.session_data = {
	start_time = nil,
	end_time = nil,
	total_time_spent = 0,
	languages = {},
}

M.file_data = {
	files = {},
}

-- Function to start the tracking session
function M.start_session()
	if M.session_data.start_time == nil then -- Only start the session once
		M.session_data.start_time = os.time()
		print("Started tracking session at " .. os.date("%X", M.session_data.start_time))
	end
end

-- Function to initialize the line count for a language on file open
function M.initialize_lines_on_open()
	local filepath = vim.fn.expand("%:p")
	local filetype = vim.bo.filetype or "unknown"
	local line_count = vim.fn.line("$")

	-- Initialize file-specific data
	if not M.file_data.files[filepath] then
		M.file_data.files[filepath] = {
			total_lines_added = 0,
			total_lines_deleted = 0,
			saved_lines = line_count, -- Initial line count on first load
			filetype = filetype,
		}
	end

	-- Initialize language data if it doesn't exist
	if not M.session_data.languages[filetype] then
		M.session_data.languages[filetype] = {
			total_lines_added = 0,
			total_lines_deleted = 0,
		}
	end
end

-- Function to track lines on file save
function M.track_lines_on_save()
	local filepath = vim.fn.expand("%:p")
	local line_count = vim.fn.line("$")
	local filetype = vim.bo.filetype or "unknown"

	-- Ensure file data is initialized
	if not M.file_data.files[filepath] then
		M.initialize_lines_on_open()
	end

	-- Calculate the difference from the last saved state
	local previous_lines = M.file_data.files[filepath].saved_lines or 0
	local diff = line_count - previous_lines

	-- Update accumulated line counts for the language
	if diff > 0 then
		M.file_data.files[filepath].total_lines_added = M.file_data.files[filepath].total_lines_added + diff
		M.session_data.languages[filetype].total_lines_added = M.session_data.languages[filetype].total_lines_added
			+ diff
	elseif diff < 0 then
		M.file_data.files[filepath].total_lines_deleted = M.file_data.files[filepath].total_lines_deleted - diff
		M.session_data.languages[filetype].total_lines_deleted = M.session_data.languages[filetype].total_lines_deleted
			- diff
	end

	-- Update saved line count to current count for the next save comparison
	M.file_data.files[filepath].saved_lines = line_count
end

function M.end_session()
	if M.session_data.start_time then -- Only end the session if it was started
		M.session_data.end_time = os.time()
		M.session_data.total_time_spent = M.session_data.end_time - M.session_data.start_time

		-- Prepare the JSON data
		local session_data = vim.fn.json_encode(M.session_data)

		-- Write JSON data to a temporary file
		local temp_file = vim.fn.tempname() .. ".json"

		local file, err = io.open(temp_file, "w")
		if not file then
			print("Error opening file for writing: " .. err)
			return
		else
			-- print("File created successfully: " .. temp_file)
		end

		local success, write_err = pcall(function()
			file:write(session_data)
			file:close()
		end)

		if not success then
			print("Error writing to file: " .. write_err)
			return
		else
			-- print("JSON data written to temporary file: " .. temp_file)
		end

		-- Use PowerShell's Invoke-RestMethod to send the data from the file
		local command = [[
			powershell -Command "Invoke-RestMethod -Uri 'https://lifesheet-production.up.railway.app/save-metrics' -Method POST -ContentType 'application/json' -InFile ']] .. temp_file .. [['"
		]]

		-- Run the system command
		local result = vim.fn.system(command)

		-- Check for errors
		if vim.v.shell_error == 0 then
			-- print("Session ended and data sent to the server successfully.")
		else
			print("Failed to send data to the server.")
			print(result) -- Output any errors
		end

		-- Clean up the temporary file
		vim.fn.delete(temp_file)
	end
end

-- Setup function to hook into events
function M.setup()
	-- Start session when NeoVim starts
	M.start_session()

	vim.api.nvim_create_autocmd("BufReadPost", {
		pattern = "*",
		callback = M.initialize_lines_on_open,
	})

	-- Track lines on file save event
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "*",
		callback = M.track_lines_on_save,
	})

	-- End session when exiting NeoVim
	vim.api.nvim_create_autocmd("VimLeavePre", {
		pattern = "*",
		callback = M.end_session,
	})
end

return M
