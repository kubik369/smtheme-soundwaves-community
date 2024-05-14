local allowedNotes = {
	["TapNoteType_Tap"] = true,
	["TapNoteType_Lift"] = true,
	-- Support the heads of the subtypes.
	["TapNoteSubType_Hold"] = true,
	["TapNoteSubType_Roll"] = true,
	-- Stamina players: you'd want to comment this out.
	["TapNoteType_HoldTail"] = true,
}

local minimumNotesInStreamMeasure = 16

-- returns
-- list of measures with >= minimumNotesInStreamMeasure notes (table of index : measure number)
-- number of measures in the song (number)
return function(steps)

	if not steps then
		return {}, 0
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

	notesInMeasure = {}
	local maxMeasure = 0

	for _, noteData in pairs(GAMESTATE:GetCurrentSong():GetNoteData(chartInt)) do

		noteBeat, _, noteType = unpack(noteData)

		if not timingData:IsJudgableAtBeat(noteBeat) or not allowedNotes[noteType] then
			goto continue
		end

		measureNumber = math.floor((noteBeat - 1) / 4) + 1

		if measureNumber > maxMeasure then
			maxMeasure = measureNumber
		end

		notesInMeasure[measureNumber] = (notesInMeasure[measureNumber] or 0) + 1

		::continue::

	end

	local streamlikeMeasures = {}

	for measure, notes in pairs(notesInMeasure) do
		if notes >= minimumNotesInStreamMeasure then
			streamlikeMeasures[#streamlikeMeasures + 1] = measure
		end
	end

	return streamlikeMeasures, maxMeasure

end
