local allowedNotes = {
	["TapNoteType_Tap"] = true,
	["TapNoteType_Lift"] = true,
	-- Support the heads of the subtypes.
	["TapNoteSubType_Hold"] = true,
	["TapNoteSubType_Roll"] = true,
	-- Stamina players: you'd want to comment this out.
	["TapNoteType_HoldTail"] = true,
}

local movingAverageSectionSeconds = 2

-- returns
-- peak NPS (number)
-- note density (table of seconds : NPS)
return function(steps)

	if not steps then
		return 0, {}
	end

	-- this is kinda meh, no? 
	local chartInt = 1
	for k, v in pairs(GAMESTATE:GetCurrentSong():GetAllSteps()) do
		if v == steps then
			chartInt = k
			break
		end
	end

	local timingData = steps:GetTimingData()
	local lastSecond = math.ceil(GAMESTATE:GetCurrentSong():GetLastSecond())

	notesInSecond = {}

	for _, noteData in pairs(GAMESTATE:GetCurrentSong():GetNoteData(chartInt)) do

		noteBeat, _, noteType = unpack(noteData)

		if not timingData:IsJudgableAtBeat(noteBeat) or not allowedNotes[noteType] then
			goto continue
		end

		noteTime = timingData:GetElapsedTimeFromBeat(noteBeat)
		notesInSecond[ math.ceil(noteTime) ] = (notesInSecond[ math.ceil(noteTime) ] or 0) + 1

		::continue::

	end

	local movingAverage = {}
	local notesInMovingWindow = 0

	for sec = 1, lastSecond do
	
		notesInMovingWindow = notesInMovingWindow + (notesInSecond[sec] or 0)

		if sec >= movingAverageSectionSeconds then
			notesInMovingWindow = notesInMovingWindow - (notesInSecond[ sec - movingAverageSectionSeconds ] or 0)
		end

		movingAverage[sec] = notesInMovingWindow / movingAverageSectionSeconds
	end

	local peakNPS = 0
	for _, nps in pairs(movingAverage) do
		if nps > peakNPS then
			peakNPS = nps
		end 
	end

	return peakNPS, movingAverage

end
