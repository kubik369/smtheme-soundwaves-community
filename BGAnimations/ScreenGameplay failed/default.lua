return Def.ActorFrame {
		-- BG animation
	Def.Quad {
		InitCommand=function(self)
			self:FullScreen():diffuse(color("#000000")):diffusealpha(0)
		end,
		OnCommand=function(self)
			self:decelerate(4.0):diffusealpha(0.5)
		end;
		};

	LoadActor("_sound") .. {
		OnCommand=function(self) self:queuecommand("Sound") end;
		SoundCommand=function(self) self:play() end;
	};	
	Def.Sprite {
		Texture="_you_died_background",
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):draworder(105) end,
		StartTransitioningCommand=function(self)
			self:diffusealpha(0):sleep(2.0):linear(0.2):diffusealpha(1):sleep(4.2):linear(1):diffusealpha(0)
		end;
	};
	Def.Sprite {
		Texture="_you_died_text",
		InitCommand=function(self) self:xy(SCREEN_CENTER_X,SCREEN_CENTER_Y):draworder(105):zoom(0.8) end,
		StartTransitioningCommand=function(self)
			self:diffusealpha(0):sleep(2.0):linear(4):zoom(1):diffusealpha(1):sleep(0.2):linear(0.3):diffusealpha(0)
		end;
	};
	LoadActor(THEME:GetPathS( Var "LoadingScreen", "failed" ) ) .. {
		StartTransitioningCommand=function(self) self:play() end;
	};

};