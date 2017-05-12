if (!isServer) exitWith {["ALiVEinit", "ALiVE Init running on client, exiting ...."] call FF7_fnc_debugLog};

call FF7_SSF_fnc_ALiVEstaticData;

_null = [] spawn FF7_SSF_fnc_ALiVEdelay;
