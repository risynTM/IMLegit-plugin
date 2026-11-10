CTrackMania@ app;
string currentMapUid;
bool isdebugScreen = true;

int currentStartTime = -1;
int currentFinishTime = -1;
int currentRaceTime = -1;

void Main() {
   @app = cast<CTrackMania>(GetApp());
}

void Update(float dt) {
    // detect map change
    if (app !is null && app.Editor is null) {
        CSmArenaClient@ currentPlayground = cast<CSmArenaClient>(app.CurrentPlayground); 
        if (currentPlayground is null || 
            currentPlayground.Map is null) {
            if (currentMapUid != "") {
                currentMapUid = "";
                startnew(onMapChange);
            }
        } else {
            if (currentMapUid != currentPlayground.Map.MapInfo.MapUid) {
                currentMapUid = currentPlayground.Map.MapInfo.MapUid;
                startnew(onMapChange);
            }
        }
        if (app.CurrentPlayground !is null)  {
            auto RaceData = MLFeed::GetRaceData_V4();
            auto player = RaceData.GetPlayer_V4(MLFeed::LocalPlayersName);
            if (player !is null) {
                generateTimestamps(player);
            }
        } 
    }
    
}

void Render () {
    drawDebugWindow();
}

void generateTimestamps(MLFeed::PlayerCpInfo_V4 player) {
    
}

void onMapChange() {
    if (currentMapUid == "") {
        print("Closed map");
    } else {
        print("Opened map: " + currentMapUid);
    }
}

void drawDebugWindow() {
    int currentBestTime = -1;
    int lastCpTime = -1;
    if (GetApp().CurrentPlayground is null || !isdebugScreen) {
        return;
    }
    // Get race data and the local player
    auto RaceData = MLFeed::GetRaceData_V4();
    auto player = RaceData.GetPlayer_V4(MLFeed::LocalPlayersName);
    if (player is null) {
        return;
    }
    if (player.IsSpawned && !player.IsFinished) {
        currentStartTime = player.StartTime;
        currentRaceTime = player.CurrentRaceTime;
        currentBestTime = player.BestTime;
        lastCpTime = player.lastCpTime;
    }
    

    UI::Begin("ImLegit - Debug", isdebugScreen);
    UI::LabelText("Time::Now", tostring(Time::Now));
    UI::LabelText("Time::Stamp", tostring(Time::Stamp));
    if (app.Editor !is null) {
        UI::LabelText("Editor Object", "exists");
    } else {
        UI::LabelText("Editor Object", "none");
    }
    UI::LabelText("Start time", tostring(currentStartTime));
    UI::LabelText("Race time", tostring(currentRaceTime));
    UI::LabelText("currentBestTime", tostring(currentBestTime));
    UI::LabelText("lastCpTime", tostring(lastCpTime));
    UI::LabelText("finishTime", tostring(player.FinishTime));
    UI::End();

}

void drawDebugWindowOld(){
    CSmArenaClient@ currentPlayground;
    CGameTerminal@ currentTerminal;
    SGamePlaygroundUIConfig::EUISequence uiSequenceCurrent = SGamePlaygroundUIConfig::EUISequence::None;
    CGamePlaygroundClientScriptAPI@ currentPlaygroundClientScriptAPI;
    int currentGameTime = -1;
    int currentStartTime = -1;
    int currentRaceTime = -1;
    int tmp = -1;
    CSmPlayer@ controlledPlayer;
    CSmPlayer@ guiPlayer;
    if (app is null || !isdebugScreen) {
        return;
    }
    if (app.Network.PlaygroundClientScriptAPI !is null) {
        @currentPlaygroundClientScriptAPI = cast<CGamePlaygroundClientScriptAPI>(app.Network.PlaygroundClientScriptAPI);
        if (currentPlaygroundClientScriptAPI !is null) {
            currentGameTime = currentPlaygroundClientScriptAPI.GameTime;
        }
    }
    if (app.CurrentPlayground !is null) {
        @currentPlayground = cast<CSmArenaClient>(app.CurrentPlayground);
        if (currentPlayground !is null && currentPlayground.GameTerminals.Length > 0) {
            @currentTerminal = currentPlayground.GameTerminals[0];
            uiSequenceCurrent = currentTerminal.UISequence_Current;

            @controlledPlayer = cast<CSmPlayer>(currentTerminal.ControlledPlayer);
            @guiPlayer = cast<CSmPlayer>(currentTerminal.GUIPlayer);
            // Spawn index is -1 in pre-run and finish menu, changes to 2. Always 2?
            if (controlledPlayer !is null && guiPlayer !is null) {
                currentStartTime = cast<CSmScriptPlayer>(controlledPlayer.ScriptAPI).StartTime;
                currentRaceTime = currentGameTime - currentStartTime;
                int tmp = currentRaceTime;
            } else if (controlledPlayer !is null && guiPlayer is null && currentRaceTime >= 0) {
                currentRaceTime = tmp;
            }

        }
    }



    UI::Begin("ImLegit - Debug", isdebugScreen);
    UI::LabelText("uiSequenceCurrent", tostring(uiSequenceCurrent));
    UI::LabelText("currentGameTime", tostring(currentGameTime));
    UI::LabelText("Time::Now", tostring(Time::Now));
    UI::LabelText("Time::Stamp", tostring(Time::Stamp));
    if (app.Editor !is null) {
        UI::LabelText("Editor Object", "exists");
    } else {
        UI::LabelText("Editor Object", "none");
    }
    UI::LabelText("Start time", tostring(currentStartTime));
    UI::LabelText("Race time", tostring(currentRaceTime));
    UI::End();
}
