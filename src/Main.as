CTrackMania@ app;
string currentMapUid;
bool isdebugScreen = true;

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
                MapChanged();
            }
        } else {
            if (currentMapUid != currentPlayground.Map.MapInfo.MapUid) {
                currentMapUid = currentPlayground.Map.MapInfo.MapUid;
                MapChanged();
            }
        }
    }
    
}

void Render () {
    drawDebugWindow();
}

void MapChanged() {
    if (currentMapUid == "") {
        print("Closed map");
    } else {
        print("Opened map: " + currentMapUid);
    }
}

void drawDebugWindow(){
    CSmArenaClient@ currentPlayground;
    CGameTerminal@ currentTerminal;
    SGamePlaygroundUIConfig::EUISequence uiSequenceCurrent = SGamePlaygroundUIConfig::EUISequence::None;
    CGamePlaygroundClientScriptAPI@ currentPlaygroundClientScriptAPI;
    int currentGameTime = -1;
    int currentStartTime = -1;
    int currentRaceTime = -1;
    CSmPlayer@ player;
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

            @player = cast<CSmPlayer>(currentTerminal.ControlledPlayer);
            // Spawn index is -1 in pre-run menu, changes to 2. Always 2?
            if (player !is null && player.SpawnIndex >= 0) {
                currentStartTime = player.StartTime;
                currentRaceTime = currentGameTime - currentStartTime;
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
    UI::End();
}