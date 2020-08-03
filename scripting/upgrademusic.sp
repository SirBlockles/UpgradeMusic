#define VERSION "1.0"

#include <sourcemod>
#include <tf2>
#include <tf2_stocks>
#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

Handle cvar_Enable;
Handle cvar_Method;
int stations[32];
Handle stationTimers[32];

public Plugin myinfo = {
	name = "Upgrade Music",
	author = "muddy",
	description = "Makes upgrade stations play their unused music.",
	version = VERSION,
	url = ""
}

public void OnPluginStart() {
	cvar_Enable = CreateConVar("sm_upgrademusic_enable", "1", "Enable/disable upgrade station music", FCVAR_ARCHIVE, true, 0.0, true, 1.0);
	cvar_Method = CreateConVar("sm_upgrademusic_method", "1", "Method 1: play music from upgrade stations themselves. More appropriate, but players have to sit around before hearing it.\nMethod 2: Play it to individual players when they enter the buy zone.", FCVAR_ARCHIVE, true, 1.0, true, 2.0);
}

public void OnMapStart() {
	PrecacheSound("items/tf_music_upgrade_machine.wav", true);
	
	//clear array from any previous values in the case of a map change
	if(stations[0] > 0) {
		for(int i = 0; i < 32; i++) {
			stations[i] = 0;
		}
		PrintToServer("Flushed previous array");
	}
	
	//find all upgrade stations, shove them into our global array
	int index = 0;
	int i = -1;
	while(i = FindEntityByClassname(i, "func_upgradestation")) {
		if(index >= 32) { PrintToServer("Capped out! Why are there more than 32 func_upgradestation's in a map??"); break; }

		//once we hit -1, we've reached the end, but since i is -1 the first time around, make sure this isn't our first rodeo.
		if(i == -1 && index > 0) { break; }
		stations[index] = i;
		index++;
	}
	
	if(!GetConVarBool(cvar_Enable)) { return; }
	
	for(int j = 0; stations[j] > 0; j++) {
		if(GetConVarInt(cvar_Method) == 1) { stationTimers[j] = CreateTimer(60.0, loopTimer, stations[j], TIMER_REPEAT); CreateTimer(0.0, loopTimer, stations[j]); }
		else { SDKHook(stations[j], SDKHook_StartTouch, OnStartTouch); }
	}
}

public void OnMapEnd() {
	//kill any and all active timers as the map ends
	for(int i = 0; i < 32; i++) {
		if(stationTimers[i] != INVALID_HANDLE) { KillTimer(stationTimers[i]); }
		else { break; }
	}
}

public Action OnStartTouch(int station, int ent) {
	char entType[32];
	GetEntityClassname(ent, entType, sizeof(entType));
	if(!StrEqual(entType, "player")) { return Plugin_Continue; }
	EmitSoundToClient(ent, "items/tf_music_upgrade_machine.wav", station, SNDCHAN_ITEM, SNDLEVEL_CAR);
	return Plugin_Continue;
}

public Action loopTimer(Handle timer, int station) {
	if(GetConVarInt(cvar_Method) == 2) { return Plugin_Stop; }
	EmitSoundToAll("items/tf_music_upgrade_machine.wav", station, SNDCHAN_AUTO, SNDLEVEL_CAR);
	return Plugin_Continue;
}