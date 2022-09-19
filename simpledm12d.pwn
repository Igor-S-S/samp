#include <a_samp>
#include <dini>
//#include "language.inc"
#include <irc>

#pragma dynamic 20480
#pragma tabsize 0

#define GameModeText "SimpleDM v.1.2e R1"

#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

main() {}

forward AntiSpawnKill(playerid);
forward LoggingTimeoutT(playerid);
forward UnMutePlayerT(playerid);
forward UnJailedPlayerT(playerid);
forward TogglePlayerControlT(playerid);
forward WorldTimeUpdate();
forward SaveAllPlayers();
forward AreasCheck();
forward AreasCheckNew();
forward IdleCheck();
forward MoneyCheck();
forward FloodCheck();
forward MoneyForPlay();
forward CountDown0();
forward CountDown1();
forward CountDown2();
forward CountDown3();
forward CountDown4();
forward CountDown5();
forward	IRC_ConnectDelay(tempid);
forward DeletiAFKLebelT();
forward hous_time();
forward reloadhouses();
forward CloseVarota(playerid);
forward AntiFloodInIRC();
forward OnPlayerToPlayerDistance(playerid);
forward ztime(); //дуэли by kroks_rus

#define BOT_1_NICKNAME "JRU-[server]"
#define BOT_1_REALNAME "SA-MP Bot"
#define BOT_1_USERNAME "bot23"
#define IRC_SERVER "irc.ivmp.ru"
#define IRC_PORT 6667
#define IRC_CHANNEL "#JRU"
#define MAX_BOTS 1
#define MAX_SERVER_PLAYERS MAX_PLAYERS

#define TimeCycle 1
//#define SolidColorChat 1
#define AllowBadSymbolsInNicks 1
#define PlayersDir "simpledm/players/"
#define PlayersExt ".txt"
//#define SystemConfig "simpledm/simpledm.cfg"
#define AdminColor 0xFFFFFFFF
#define GameModeLog "simpledm/simpledm.log"
//#define CommandsLog "simpledm/commands.log"
#define AdminsLog "simpledm/admins.log"
#define MutesLog "simpledm/mutes.log"
#define KicksLog "simpledm/kicks.log"
#define BansLog "simpledm/bans.log"
#define AntiCheatLog "simpledm/anticheat.log"
#define RconCommandsLog "simpledm/rconcommands.log"
#define MaxLogFileSize 10485760

#define PrivateMsgColor 0x00FF00AA
#define AdminChatColor 0xFF8000AA
#define SystemMsgColor 0xFFFF00AA
#define ErrorMsgColor 0xFF0000AA
#define HelpMsgColor 0x00FF00AA
#define FreezeMsgColor 0xFF0000AA
#define MuteMsgColor 0xFF0000AA
#define KickMsgColor 0xFF0000AA
#define BanMsgColor 0xFF0000AA
#define AdminSayColor 0x2587ceAA
#define ConnectMsgColor 0xC0C0C0AA
#define YellowColor 0xFFFF00AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
//#define AutoLoggins 1

#define MoneysForKill 1000
#define MoneysForPlaying 500

#define IdleTimeToKick 60
#define IdleTimeToAfk 5
#define FloodInterval 2
#define FloodLines 3
#define LoggingTimeout 20
#define LoggingColor 0x22222200
#define AntiSpawnKillTime 5
#define LegalKillDistance 75
#define NoDriveBy 1
#define NoTeamKill 1
#define MaxMoneyIllegalIncrease 2000000
//#define MoneyCheckOn 1
//#define InDoorWeapons 1
#define MaxChatLinies 100
#define CheatWeapons1 21
new CheatWeapon1[CheatWeapons1] = {1,6,7,10,11,12,13,14,15,17,18,22,26,27,28,32,35,36,37,38,41};
#define FlameCheatsToBan 3
#define DeathsFromCheatToBan 3
#define AdminLevelToIgnorePunishment 6
#define DeleteAFKInterval 1

//#define IrcOnOff 0 //On=1, off=0
//#define Houses 0

#define MaxPresedC 5
new PressedC[MAX_PLAYERS];

new gPlayersInGame;
new gPlayerSelect;
new gBansss,glegalkill;
new gPrivatMsg[MAX_STRING];
new vorota1,vorota2;

new gduel,gplay1,gplay2,gweapon2,gzone,gtimm,gDuelTetATet;//дуэли by kroks_rus

#if defined IrcOnOff
#define IRCFloodInterval 3
new	gBotID[MAX_BOTS],gGroupID,gIRC_pass[20],gBotNoSay;
//gBotConnect[MAX_BOT],
public AntiFloodInIRC(){
   if(gBotNoSay) return gBotNoSay=0;
   else return 0;
}

#endif

#if defined HousesOnOff
#define MAX_HOUSES 50
	enum hosesinf {
	    user_h[MAX_STRING],
		Float:X_h_in,
		Float:Y_h_in,
		Float:Z_h_in,
		Float:X_h_out,
		Float:Y_h_out,
		Float:Z_h_out,
		Float:X_h_spawn,
		Float:Y_h_spawn,
		Float:Z_h_spawn,
		word_h,
		inter_h,
		locked_h,
		uncreat_h

	}
#define picups 10 //Реальное Кол во пикапов

	enum picupsinf {
		Float:X_p,
		Float:Y_p,
		Float:Z_p,
		model_p,
		weapon_p,
		patron_p,
		text_p[250],
		type_p

	}
new picaps[picups][picupsinf] = {  // Игорь исправь. я переделал
// {X,Y,Z,model,weapon,patron}
	{-2512.5027,2293.1809,4.9844,342,16,50,"",19},//Гранаты (проход)
	{-2188.9434,2412.7510,5.1563,353,29,1000,"",19},//Крыша 1
	{-2185.5295,2416.9670,5.1882,358,34,500,"",19},//Будка (на пляже)
	{-2638.6506,2334.7573,8.5206,356,31,2000,"",19},//Будка (на пляже)
	{-2292.6333,2289.2910,4.9213,348,24,1000,"",19},//Крыша 2 (рядом с водой)
	{-2291.4417,2325.8713,15.1493,341,9,1,"",19},//Крыша 2 (рядом с водой)
	{-2291.6104,2294.6516,15.2222,349,25,500,"",19},//Крыша 3
	{-2237.0188,2362.5415,10.1875,353,29,1000,"",19},//Крыша 4
	{-2121.0115,2528.2747,49.8723,1274,0,5000,"Вы нашли сундук сокровищ!",19},//Сундук сокровищ! Пляж
	{-2632.7441,2415.6287,23.6989,356,31,1000,"",19}//Крыша 5



};
new pick[picups];
new houses[MAX_HOUSES][hosesinf];
new pic_in[MAX_HOUSES];
new pic_out[MAX_HOUSES];
new pic_spawn[MAX_HOUSES];
new houses_load;
HousesFile(hid) {
	new str[MAX_STRING];
	format(str,sizeof(str),"%s%d%s","simpledm/houses/",hid,".txt");
	return str;
}

addhouse(){
    dini_IntSet("simpledm/houses/main.txt","all",houses_load+1);
    houses_load++;

}
loadhouses(){

	new i,to;
	printf(">>>>Houses inicializates........");
    to=dini_Int("simpledm/houses/main.txt","all");
    houses_load=to;
    for (i=1; i<=to; i++){
 	houses[i][locked_h]=false;
    if (!dini_Exists(HousesFile(i))){
    //printf("DON'T exist!!!   %s",HousesFile(i));
    dini_Create(HousesFile(i));
    }
    houses[i][user_h]=dini_Get(HousesFile(i),"USER");
    houses[i][X_h_in]=dini_Float(HousesFile(i),"IN_X");
    houses[i][Y_h_in]=dini_Float(HousesFile(i),"IN_Y");
    houses[i][Z_h_in]=dini_Float(HousesFile(i),"IN_Z");
    houses[i][X_h_out]=dini_Float(HousesFile(i),"OUT_X");
    houses[i][Y_h_out]=dini_Float(HousesFile(i),"OUT_Y");
    houses[i][Z_h_out]=dini_Float(HousesFile(i),"OUT_Z");
    houses[i][X_h_spawn]=dini_Float(HousesFile(i),"SPAWN_X");
    houses[i][Y_h_spawn]=dini_Float(HousesFile(i),"SPAWN_Y");
    houses[i][Z_h_spawn]=dini_Float(HousesFile(i),"SPAWN_Z");
    houses[i][word_h]=dini_Int(HousesFile(i),"WORD");
    houses[i][inter_h]=dini_Int(HousesFile(i),"INTER");
    //printf("%d    %s",i,houses[i][user_h]);
	//printf("%d",i);
	}

	//dini_Create("simpledm/houses/11.txt");
	dini_Create(HousesFile(11));
	new str[200];
	format(str,sizeof(str),">>>>Houses by kroks has loaded #%d",i-1);
	printf(str);
	house_picaps();

}
stock gethouseid(playerid){
    new temp;
    temp=false;
    for (new i=1;i<=houses_load;i++){
    if (strcmp(PlayerInfo[playerid][Name],houses[i][user_h], true) == 0){
    temp=true;
    break;
    }
    }
    if (temp){
    return i;
    }
    else
    {
    return 0;
    }

}

stock ishouse(playerid){
    new temp;
    temp=false;
    for (new i=1;i<=houses_load;i++){
    if (strcmp(PlayerInfo[playerid][Name],houses[i][user_h], true) == 0){
    temp=true;
    break;
    }
    }
    return temp;

}
stock tohouse(playerid){
    if(ishouse(playerid)){
    new i;
    i=gethouseid(playerid);
    new tmp[200];
    format(tmp,sizeof(tmp),"Вы воскресли в доме, адрес ул.Административная, дом №,%d",i);
    SendClientMessage(playerid, 0x00FF00AA,tmp);
    SetPlayerInterior(playerid, houses[i][inter_h]);
    SetPlayerPos(playerid,houses[i][X_h_out],houses[i][Y_h_out],houses[i][Z_h_out]);
    SetPlayerVirtualWorld(playerid,i);
    destroy_houses_pickup(5,i);
    }
}
public reloadhouses(){

	new i,to;
	printf(">>>>Houses inicializates........");
    to=dini_Int("simpledm/houses/main.txt","all");
    houses_load=to;
    for (i=1; i<=to; i++){
    houses[i][locked_h]=false;
    if (!dini_Exists(HousesFile(i))){
    //printf("DON'T exist!!!   %s",HousesFile(i));
    dini_Create(HousesFile(i));
    }
    houses[i][user_h]=dini_Get(HousesFile(i),"USER");
    houses[i][X_h_in]=dini_Float(HousesFile(i),"IN_X");
    houses[i][Y_h_in]=dini_Float(HousesFile(i),"IN_Y");
    houses[i][Z_h_in]=dini_Float(HousesFile(i),"IN_Z");
    houses[i][X_h_out]=dini_Float(HousesFile(i),"OUT_X");
    houses[i][Y_h_out]=dini_Float(HousesFile(i),"OUT_Y");
    houses[i][Z_h_out]=dini_Float(HousesFile(i),"OUT_Z");
    houses[i][X_h_spawn]=dini_Float(HousesFile(i),"SPAWN_X");
    houses[i][Y_h_spawn]=dini_Float(HousesFile(i),"SPAWN_Y");
    houses[i][Z_h_spawn]=dini_Float(HousesFile(i),"SPAWN_Z");
    houses[i][word_h]=dini_Int(HousesFile(i),"WORD");
    houses[i][inter_h]=dini_Int(HousesFile(i),"INTER");
    //printf("%d    %s",i,houses[i][user_h]);
	//printf("%d",i);
	}

	//dini_Create("simpledm/houses/11.txt");
	dini_Create(HousesFile(11));
	new str[200];
	format(str,sizeof(str),">>>>Houses by kroks has reloaded #%d",i-1);
	printf(str);
	house_picaps_destroy();
	house_picaps();

}
house_picaps_destroy(){
	for (new i=1; i<=houses_load; i++){
    DestroyPickup(pic_in[i]);
    DestroyPickup(pic_out[i]);
    DestroyPickup(pic_spawn[i]);
	}
}
house_picaps(){
    for (new i=1; i<=houses_load; i++){
    pic_in[i] = CreatePickup ( 1272, 1, houses[i][X_h_in], houses[i][Y_h_in], houses[i][Z_h_in] ,-1);
    pic_out[i] = CreatePickup ( 1239, 1, houses[i][X_h_out], houses[i][Y_h_out],houses[i][Z_h_out],houses[i][word_h]);
    pic_spawn[i]=CreatePickup ( 1239, 1, houses[i][X_h_spawn], houses[i][Y_h_spawn],houses[i][Z_h_spawn],houses[i][word_h]);
	}
}
stock destroy_houses_pickup(time,i){
    DestroyPickup(pic_in[i]);
    DestroyPickup(pic_out[i]);
    DestroyPickup(pic_spawn[i]);
    houses[i][uncreat_h]=time;


}
public  hous_time(){
    for (new i=1;i<=houses_load;i++){
    if (houses[i][uncreat_h]>0){
    houses[i][uncreat_h]--;
    }
    else if (houses[i][uncreat_h]==0){
    //SendClientMessageToAll(0xDEEE20FF, "Пересоздание пикапов.");
    pic_in[i] = CreatePickup ( 1272, 1, houses[i][X_h_in], houses[i][Y_h_in], houses[i][Z_h_in]+0.005 ,-1);
    pic_out[i] = CreatePickup ( 1239, 1, houses[i][X_h_out], houses[i][Y_h_out],houses[i][Z_h_out],i);
    pic_spawn[i]=CreatePickup ( 1239, 1, houses[i][X_h_spawn], houses[i][Y_h_spawn],houses[i][Z_h_spawn],i);

    houses[i][uncreat_h]=-1;
    }
    }



}
#endif
FixChars(string[]) for (new i=0;i<strlen(string);i++) if (string[i] < 0) string[i] += 256;

WriteToLog(text[],file[]=GameModeLog) {
	new day,mon,year,hr,mn,sec;
	new str[MAX_STRING];
	getdate(year,mon,day);
	gettime(hr,mn,sec);
	format(str,sizeof(str),"%d.%d.%d [%d:%d:%d] %s",day,mon,year,hr,mn,sec,text);
	if (equal(file,GameModeLog,false)) print(str);
	new File:f = fopen(file,io_append);
	#if defined MaxLogFileSize
		if (flength(f) > MaxLogFileSize) {
			fclose(f);
			new tmp[MAX_STRING];
			format(tmp,sizeof(tmp),"%s_%d.%d.%d.log",file,day,mon,year);
			fcopytextfile(file,tmp);
			fremove(file);
			f = fopen(file,io_append);
		}
	#endif
	fwrite(f,str);
	fwrite(f,"\r\n");
	fclose(f);
}
#define Type 1
#define DialogID 0
#define Button1 "Ok"
#define Button2 "Cancel"
WriteEcho(text[],playerid=INVALID_PLAYER_ID,color=SystemMsgColor,type=Type,dialogid=DialogID,title[]="",main[]="",button1[]=Button1,button2[]=Button2) {
	new h,m,s;
	new str[MAX_STRING];
	gettime(h,m,s);
	format(str,sizeof(str),"[%d:%d:%d] %s",h,m,s,text);
	if(type==1 || !type){//type=1 - вывод в чат
	if (playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) SendClientMessage(playerid,color,str);
	else SendClientMessageToAll(color,str);
	}
	if(type==2){//type=2 - вывод диалога с полем ввода
    ShowPlayerDialog(playerid,dialogid,DIALOG_STYLE_INPUT,title,main,button1,button2);
	}
	if(type==3){//type=3 - вывод обычного диалога
    ShowPlayerDialog(playerid,dialogid,DIALOG_STYLE_MSGBOX,title,main,button1,button2);
 	}
	if(type==4){//type=4 - вывод диалога "Select"
    ShowPlayerDialog(playerid,dialogid,DIALOG_STYLE_LIST,title,main,button1,button2);
 	}
 	if(type==5){//type=5 - IRC
	format(str,sizeof(str),"[%d:%d:%d] %s",h,m,s,text);
    //IRC_GroupSay(gGroupID, IRC_CHANNEL,str);
 	}
}

#define Teams 14
#if defined Teams
	#define ModelsInTeam 9
	enum TeamInfos {
		TeamName[20],
		TeamColor,
		TeamModels[ModelsInTeam],
		TeamClassStart,
		TeamClassEnd,
		TeamSpawnInterior,
		Float:TeamSpawnX,
		Float:TeamSpawnY,
		Float:TeamSpawnZ,
		Float:TeamSpawnA
	}
	new TeamInfo[Teams][TeamInfos] = {
	    {"~b~Police",		0x3C3CE3AA,	{280,281,288},						    0,0,0,2297.4934,2402.9165,13.4186,196.1839},
		{"~w~Medic",		0x00FF55AA,	{274,275,276},							0,0,0,1627.8563,1846.7421,10.8203,321.5257},
		{"~w~Business",		0xFFD700FF,	{216,240,59},						    0,0,0,2087.0239,1911.4628,12.4979,293.4867},
		{"~w~Pilot",		0x179FF0AA,	{170,184,188},						    0,0,0,1650.8285,1590.3309,10.8203,358.8573},
		{"~w~Triads",		0xFF8000AA,	{117,118,120},						    0,0,0,2035.6432,1007.8312,10.8203,270.7527},
		{"~w~Girl",			0xFF7575AA,	{152,190,192},  						0,0,0,1098.1315,1704.3099,10.8203,358.2987},
		{"~r~Mafia",		0xB30000AA,	{111,112,113},						    0,0,0,1314.4696,2020.3650,11.3352,86.9045},//мафия
		{"~w~Builders",		0x800080FF,	{260,16},   						    0,0,0,2441.9507,1954.7627,10.8001,269.0497},//строители
		{"~w~Bikers",		0x996600AA,	{247,248},  						    0,0,0,2636.1257,2351.1023,10.8128,173.9687},//байкеры
		{"~b~Aztecas",		0x00FFFFFF,	{114,115,116},						    0,0,0,1390.4718,2668.2859,10.8203,358.5631},
		{"~w~Goverment",	0x808080FF,	{165,166,295},						    0,0,0,1249.7217,-2025.5818,59.7143,269.1162},
		{"~y~Da Nang Boys",	0xF0E68CFF,	{121,122,123},						    0,0,0,1967.4063,1622.2828,12.8682,270.4288},
		{"~w~Rifa",			0xB0E0E6FF,	{173,174,175},						    0,0,0,1053.4744,2148.0994,10.8203,89.7969},
		{"~y~Criminals",	0x999999FF,	{28,29,30},							    0,0,0,2621.9724,1983.8284,12.6400,273.0491}
	};
#endif

#define Classes 259
new ClassInfo[Classes] = {
	7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,43,44,45,46,47,48,49,
	50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,66,67,68,69,70,71,72,73,75,76,77,78,79,80,81,82,83,84,85,87,88,89,90,91,92,
	93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,120,121,122,123,124,125,
	126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,150,151,152,153,154,155,156,
	157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,
	187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,209,210,211,212,213,214,215,216,217,
	218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,
	248,249,250,251,252,253,254,255,280,281,282,283,284,285,286,287,290,291,292,293,294,295,296,297,298,299
};

new DefaultPlayerColors[MAX_PLAYERS] = {
	0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,
	0x2D74FDFF,0x3C1C0DFF,0x12D6D4FF,0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,
	0x42ACF5FF,0x2FD9DEFF,0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1EF2FF,0x93B7E4FF,
	0x3214AAFF,0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,0xDCDE3DFF,
	0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,0xD8C762FF,0x3FE65CFF,
	0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xF0E68CFF,0x778899FF,0xFF1493FF,0xF4A460FF,0xEE82EEFF,
	0xFFD720FF,0x8B4513FF,0x4949A0FF,0x148B8BFF,0x14FF7FFF,0x556B2FFF,0x0FD9FAFF,0x10DC29FF,0x534081FF,0x0495CDFF,
	0xEF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,0x65ADEBFF,0x5C1ACCFF,0xF2F853FF,0x11F891FF,
	0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,0x3D0A4FFF,0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,
	0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,0x057F94FF,0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF
};

#define Vehicles 340
enum VehicleInfos {
	VehicleModelID,
	Float:VehicleSpawnX,
	Float:VehicleSpawnY,
	Float:VehicleSpawnZ,
	Float:VehicleSpawnA,
	VehicleColor1,
	VehicleColor2
}
new VehicleInfo[Vehicles][VehicleInfos] = {
	{489,2441.7852,707.9503,11.3088,90.6781,-1,-1}, // Auto (ID: 401) // LV
	{480,2405.2776,647.0684,10.9135,181.4007,-1,-1}, // Auto (ID: 402) // LV
	{477,2352.2764,646.8680,10.8586,182.7451,-1,-1}, // Auto (ID: 403) // LV
	{475,2265.3450,647.2432,10.9623,180.8831,-1,-1}, // Auto (ID: 404) // LV
	{470,2212.3630,645.8705,11.0264,182.0241,-1,-1}, // Auto (ID: 405) // LV
	{484,2363.3972,517.3277,0.1560,87.7908,-1,-1}, // Auto (ID: 406) // LV
	{463,2128.4897,688.3826,10.7687,176.4257,-1,-1}, // Auto (ID: 407) // LV
	{458,2085.9578,659.5742,11.0049,355.7204,-1,-1}, // Auto (ID: 408) // LV
	{457,2048.6384,685.5425,10.6428,182.5758,-1,-1}, // Auto (ID: 409) // LV
	{451,2005.6550,686.7403,10.9027,179.2034,-1,-1}, // Auto (ID: 410) // LV
	{429,2006.5552,658.2772,10.9085,1.2406,-1,-1}, // Auto (ID: 411) // LV
	{424,2048.9678,741.0876,10.8803,359.8754,-1,-1}, // Auto (ID: 412) // LV
	{420,2008.6050,766.1199,10.9330,179.4185,-1,-1}, // Auto (ID: 413) // LV
	{415,2087.8923,766.8118,10.9601,184.5569,-1,-1}, // Auto (ID: 414) // LV
	{411,2127.8267,739.7001,10.9254,358.5836,-1,-1}, // Auto (ID: 415) // LV
	{409,2161.3364,779.4047,11.0139,88.1819,-1,-1}, // Auto (ID: 416) // LV
	{405,2184.9058,726.5880,10.9800,179.4447,-1,-1}, // Auto (ID: 417) // LV
	{403,2222.1833,699.2065,11.7254,358.0295,-1,-1}, // Auto (ID: 418) // LV
	{402,2265.2893,727.1816,10.9796,177.8104,-1,-1}, // Auto (ID: 419) // LV
	{402,2361.3289,700.0333,10.8959,0.1612,-1,-1}, // Auto (ID: 420) // LV
	{402,1921.1599,728.4103,10.6521,179.6460,-1,-1}, // Auto (ID: 421) // LV
	{400,1931.7915,679.5811,10.9126,2.0209,-1,-1}, // Auto (ID: 422) // LV
	{534,1694.4380,698.8752,10.5444,1.1905,-1,-1}, // Auto (ID: 423) // LV
	{536,1694.1127,749.4155,10.5576,181.2383,-1,-1}, // Auto (ID: 424) // LV
	{535,1633.3901,743.5004,10.5842,178.0558,-1,-1}, // Auto (ID: 425) // LV
	{541,1632.5349,691.5687,10.4452,357.8191,-1,-1}, // Auto (ID: 426) // LV
	{554,1413.9655,685.6152,10.9017,271.2823,-1,-1}, // Auto (ID: 427) // LV
	{559,1412.9626,712.7130,10.4767,267.2238,-1,-1}, // Auto (ID: 428) // LV
	{560,1413.2600,753.9628,10.5256,269.5103,-1,-1}, // Auto (ID: 429) // LV
	{561,1451.8695,786.7828,10.6338,179.1000,-1,-1}, // Auto (ID: 430) // LV
	{562,1486.6465,786.9848,10.4801,180.9859,-1,-1}, // Auto (ID: 431) // LV
	{558,1513.1349,787.2015,10.4508,179.2433,-1,-1}, // Auto (ID: 432) // LV
	{487,1530.9086,709.6375,10.9921,134.3282,-1,-1}, // Auto (ID: 433) // LV
	{457,1378.9326,772.8116,10.4470,89.5724,-1,-1}, // Auto (ID: 434) // LV
	{457,1378.4579,753.5276,10.4476,89.1544,-1,-1}, // Auto (ID: 435) // LV
	{457,1378.2770,731.3214,10.4471,90.8734,-1,-1}, // Auto (ID: 436) // LV
	{457,1378.2238,704.5875,10.4471,88.2090,-1,-1}, // Auto (ID: 437) // LV
	{457,1377.9309,677.0974,10.4548,89.4878,-1,-1}, // Auto (ID: 438) // LV
	{400,1409.2708,977.5206,10.9099,1.5198,-1,-1}, // Auto (ID: 439) // LV
	{402,1470.5958,978.8910,10.6520,359.4373,-1,-1}, // Auto (ID: 440) // LV
	{405,1472.6719,1051.7219,10.6951,271.1427,-1,-1}, // Auto (ID: 441) // LV
	{406,1379.4977,1083.4039,12.3421,272.0744,-1,-1}, // Auto (ID: 442) // LV
	{411,1666.6631,1028.0388,10.5474,179.5291,-1,-1}, // Auto (ID: 443) // LV
	{415,1665.7351,988.4426,10.5916,179.9856,-1,-1}, // Auto (ID: 444) // LV
	{406,1692.9845,940.7792,12.3282,359.8250,-1,-1}, // Auto (ID: 445) // LV
	{405,1039.7521,1211.3640,10.6953,186.0378,-1,-1}, // Auto (ID: 446) // LV
	{405,1063.8536,1212.1552,10.6952,184.2705,-1,-1}, // Auto (ID: 447) // LV
	{411,1024.4504,1350.9410,10.5474,46.7865,-1,-1}, // Auto (ID: 448) // LV
	{411,1020.9246,1324.6149,10.5474,44.4222,-1,-1}, // Auto (ID: 449) // LV
	{573,1067.8738,1242.3641,11.4760,300.5706,-1,-1}, // Auto (ID: 450) // LV
	{573,1064.3842,1261.9496,11.4703,293.5660,-1,-1}, // Auto (ID: 451) // LV
	{573,1064.2130,1287.2749,11.4705,295.0498,-1,-1}, // Auto (ID: 452) // LV
	{563,1061.4792,1330.3148,11.5251,270.8586,-1,-1}, // Auto (ID: 453) // LV
	{562,1100.8564,1729.6573,10.4800,0.3593,-1,-1}, // Auto (ID: 457) // LV
	{562,1086.3253,1729.3866,10.4793,359.3897,-1,-1}, // Auto (ID: 458) // LV
	{561,1072.6940,1729.1111,10.6339,3.1434,-1,-1}, // Auto (ID: 459) // LV
	{561,1055.9047,1727.8962,10.6343,2.7384,-1,-1}, // Auto (ID: 460) // LV
	{559,1033.7813,1726.8911,10.4767,2.1774,-1,-1}, // Auto (ID: 461) // LV
	{561,952.7117,1717.7372,8.4622,359.8318,-1,-1}, // Auto (ID: 462) // LV
	{560,952.2300,1741.1434,8.3532,1.8296,-1,-1}, // Auto (ID: 463) // LV
	{522,983.6848,1731.4574,8.2266,96.8617,-1,-1}, // Auto (ID: 464) // LV
	{541,920.4215,1921.1534,10.6857,89.2876,-1,-1}, // Auto (ID: 465) // LV
	{554,894.3312,1974.4523,11.2429,269.2587,-1,-1}, // Auto (ID: 466) // LV
	{558,894.7271,2041.2119,10.7627,269.7213,-1,-1}, // Auto (ID: 467) // LV
	{561,993.8173,2350.8301,10.9414,270.5187,-1,-1}, // Auto (ID: 468) // LV
	{562,991.9340,2279.8792,10.8441,359.6455,-1,-1}, // Auto (ID: 469) // LV
	{554,1038.4288,2221.0298,10.9084,65.5744,-1,-1}, // Auto (ID: 470) // LV
	{541,974.4485,2118.6694,10.4452,266.0290,-1,-1}, // Auto (ID: 471) // LV
	{524,977.4845,2139.9219,11.7439,260.0193,-1,-1}, // Auto (ID: 472) // LV
	{524,980.2330,2168.3042,11.7458,234.7257,-1,-1}, // Auto (ID: 473) // LV
	{524,1039.0254,2132.5820,11.7460,102.7456,-1,-1}, // Auto (ID: 474) // LV
	{522,1020.0313,1969.4143,10.6336,89.4165,-1,-1}, // Auto (ID: 475) // LV
	{518,994.3203,1994.2643,10.8335,268.6855,-1,-1}, // Auto (ID: 476) // LV
	{510,1021.8107,2021.0719,10.7726,86.4170,-1,-1}, // Auto (ID: 477) // LV
	{507,1093.7087,2038.2798,10.9354,269.0635,-1,-1}, // Auto (ID: 478) // LV
	{505,1094.2456,1983.2430,11.2430,268.9175,-1,-1}, // Auto (ID: 479) // LV
	{515,1084.9600,1876.6993,11.8348,271.2345,-1,-1}, // Auto (ID: 480) // LV
	{515,1078.2628,1851.4607,11.8563,299.9317,-1,-1}, // Auto (ID: 481) // LV
	{515,1158.2672,1912.5398,11.8567,82.6458,-1,-1}, // Auto (ID: 482) // LV
	{450,1114.5208,1852.5670,11.4553,0.9269,-1,-1}, // Auto (ID: 483) // LV
	{450,1057.2444,1922.0941,11.4491,0.1461,-1,-1}, // Auto (ID: 484) // LV
	{450,1079.9749,1919.6797,11.4483,0.0468,-1,-1}, // Auto (ID: 485) // LV
	{553,1344.8070,1486.3015,12.1566,270.7300,-1,-1}, // Samolet (ID: 486) // Airport LV
	{563,1393.0995,1770.4304,11.5216,269.3680,-1,-1}, // Samolet (ID: 487) // Airport LV
	{592,1477.5146,1794.9098,12.0089,179.3755,-1,-1}, // Samolet (ID: 488) // Airport LV
	{593,1541.8738,1749.9518,11.2815,91.6905,-1,-1}, // Samolet (ID: 489) // Airport LV
	{593,1543.5435,1694.0227,11.2834,93.8671,-1,-1}, // Samolet (ID: 490) // Airport LV
	{519,1345.7233,1567.8428,11.7423,266.7549,-1,-1}, // Samolet (ID: 491) // Airport LV
	{519,1346.0461,1620.5051,11.7391,270.3696,-1,-1}, // Samolet (ID: 492) // Airport LV
	{417,1350.3156,1682.5239,10.9199,271.1916,-1,-1}, // Samolet (ID: 493) // Airport LV
	{476,1296.1392,1402.4532,11.5260,239.4477,-1,-1}, // Samolet (ID: 494) // Airport LV
	{476,1284.0519,1323.6479,11.5333,268.9417,-1,-1}, // Samolet (ID: 495) // Airport LV
	{476,1284.5273,1361.4644,11.5306,269.1714,-1,-1}, // Samolet (ID: 496) // Airport LV
	{451,1325.5367,1279.7871,10.5272,359.7231,-1,-1}, // Samolet (ID: 497) // Airport LV
	{437,1279.1240,1267.9631,10.9515,1.3420,-1,-1}, // Samolet (ID: 498) // Airport LV
	{429,1308.9835,1279.1547,10.5000,0.2067,-1,-1}, // Samolet (ID: 499) // Airport LV
	{577,1586.1599,1190.8560,10.7332,179.1738,-1,-1}, // Auto (ID: 500) // Airport LV
	{548,1561.7319,1450.2299,12.4750,88.0099,-1,-1}, // Auto (ID: 501) // Airport LV
	{487,1659.8351,1557.2159,10.9876,34.3861,-1,-1}, // Auto (ID: 502) // Airport LV
	{488,1620.5682,1548.6196,11.1010,349.8845,-1,-1}, // Auto (ID: 503) // Airport LV
	{480,1702.3396,1585.8490,10.4015,39.5467,-1,-1}, // Auto (ID: 504) // Airport LV
	{477,1669.8734,1631.1390,10.5772,200.9643,-1,-1}, // Auto (ID: 505) // Airport LV
	{451,1714.7144,1642.2744,9.8653,152.8913,-1,-1}, // Auto (ID: 506) // Airport LV
	{541,1374.2109,1904.0032,10.7242,270.6867,-1,-1}, // Auto (ID: 507) // LV
	{554,1400.0803,1912.7079,11.2179,89.4969,-1,-1}, // Auto (ID: 508) // LV
	{559,1373.8903,1938.3210,10.7539,269.3250,-1,-1}, // Auto (ID: 509) // LV
	{560,1315.1244,1939.6112,10.9082,0.7237,-1,-1}, // Auto (ID: 510) // LV
	{561,1310.1106,2011.9111,10.9533,93.3474,-1,-1}, // Auto (ID: 511) // LV
	{562,1300.3740,2083.2581,10.4767,218.8476,-1,-1}, // Auto (ID: 512) // LV
	{565,1373.6418,2012.0570,10.7453,271.6040,-1,-1}, // Auto (ID: 513) // LV
	{567,1417.9298,1958.5864,11.1364,357.3662,-1,-1}, // Auto (ID: 514) // LV
	{579,1437.6967,2014.0765,10.7530,216.3849,-1,-1}, // Auto (ID: 515) // LV
	{581,1518.5474,2016.5697,10.4161,139.2609,-1,-1}, // Auto (ID: 516) // LV
	{587,1541.5105,2089.5979,10.8978,90.5684,-1,-1}, // Auto (ID: 517) // LV
	{402,1605.1812,2141.8325,11.0055,269.7924,-1,-1}, // Auto (ID: 518) // LV
	{403,1632.7999,2108.6704,11.6805,90.0741,-1,-1}, // Auto (ID: 519) // LV
	{405,1604.6083,2077.7700,10.8441,271.1686,-1,-1}, // Auto (ID: 520) // LV
	{411,1632.1021,2038.3931,10.6935,93.7456,-1,-1}, // Auto (ID: 521) // LV
	{415,1694.0747,2053.8752,10.8811,272.2309,-1,-1}, // Auto (ID: 522) // LV
	{412,1694.3602,2088.1560,10.9985,265.8170,-1,-1}, // Auto (ID: 523) // LV
	{418,1694.2229,2131.1270,11.1795,267.1754,-1,-1}, // Auto (ID: 524) // LV
	{420,1575.5603,1929.9579,10.5998,86.2518,-1,-1}, // Auto (ID: 525) // LV
	{424,1592.2255,1967.2734,10.6007,167.8197,-1,-1}, // Auto (ID: 526) // LV
	{429,1667.0809,1960.5116,10.5000,126.2817,-1,-1}, // Auto (ID: 527) // LV
	{436,1682.6499,1917.8805,10.5889,337.0297,-1,-1}, // Auto (ID: 528) // LV
	{451,1731.1987,1900.2311,10.5158,271.8878,-1,-1}, // Auto (ID: 529) // LV
	{458,1752.6029,1925.0624,10.6985,359.0304,-1,-1}, // Auto (ID: 530) // LV
	{416,1601.3982,1849.1007,10.9692,177.1078,-1,-1}, // Auto (ID: 531) // LV
	{416,1619.5648,1849.0914,10.9693,178.6991,-1,-1}, // Auto (ID: 532) // LV
	{418,1666.8518,1791.6183,10.9139,46.4260,-1,-1}, // Auto (ID: 533) // LV
	{405,1693.1160,2199.8662,10.6952,179.0060,-1,-1}, // Auto (ID: 534) // LV
	{402,1745.0815,2217.2681,10.6519,111.2261,-1,-1}, // Auto (ID: 535) // LV
	{400,1689.6653,2325.6775,10.9127,264.4636,-1,-1}, // Auto (ID: 536) // LV
	{406,1692.1652,2354.6582,12.3531,219.9739,-1,-1}, // Auto (ID: 537) // LV
	{405,1633.1119,2324.7720,10.6955,126.2670,-1,-1}, // Auto (ID: 538) // LV
	{411,1626.7593,2238.9177,10.5474,339.9106,-1,-1}, // Auto (ID: 539) // LV
	{420,1499.9524,2202.7974,10.6015,178.8403,-1,-1}, // Auto (ID: 540) // LV
	{426,1525.7988,2258.1641,10.5628,179.6593,-1,-1}, // Auto (ID: 541) // LV
	{429,1495.4628,2280.4492,10.4996,181.4371,-1,-1}, // Auto (ID: 542) // LV
	{428,1536.1542,2279.8701,10.9444,176.7274,-1,-1}, // Auto (ID: 543) // LV
	{431,1310.1583,2248.7708,10.9290,299.1317,-1,-1}, // Auto (ID: 544) // LV
	{434,1357.5831,2276.7893,10.7890,88.5224,-1,-1}, // Auto (ID: 545) // LV
	{451,1357.8970,2249.8030,10.5215,89.9668,-1,-1}, // Auto (ID: 546) // LV
	{455,1384.3790,2244.5627,11.2575,88.4198,-1,-1}, // Auto (ID: 547) // LV
	{455,1397.9598,2277.1323,11.2780,270.1624,-1,-1}, // Auto (ID: 548) // LV
 	{522,1482.1282,2878.0479,10.3823,178.8716,-1,-1}, // Auto (ID: 549) // LV
	{521,1460.0013,2878.6633,10.3917,175.7167,-1,-1}, // Auto (ID: 550) // LV
	{457,1423.3250,2838.6982,10.4471,271.0512,-1,-1}, // Auto (ID: 551) // LV
	{457,1423.2617,2856.3767,10.4471,272.4726,-1,-1}, // Auto (ID: 552) // LV
	{457,1460.4650,2840.6809,10.4471,359.3688,-1,-1}, // Auto (ID: 553) // LV
	{457,1528.7623,2844.9807,10.4471,92.1145,-1,-1}, // Auto (ID: 554) // LV
	{457,1528.6594,2804.6897,10.4471,90.2274,-1,-1}, // Auto (ID: 555) // LV
	{562,1494.1006,2838.9001,10.4792,2.1639,-1,-1}, // Auto (ID: 556) // LV
	{561,1475.0437,2847.6667,10.6341,359.8591,-1,-1}, // Auto (ID: 557) // LV
	{561,1594.4077,2834.1731,10.6337,236.6192,-1,-1}, // Auto (ID: 558) // LV
	{559,1629.5082,2808.9255,10.4837,333.9098,-1,-1}, // Auto (ID: 559) // LV
	{554,1673.4150,2698.1023,10.9089,1.3576,-1,-1}, // Auto (ID: 560) // LV
	{579,1607.5723,2720.3958,10.7519,46.6962,-1,-1}, // Auto (ID: 561) // LV
	{579,1275.1976,2696.5522,10.7539,358.8490,-1,-1}, // Auto (ID: 562) // LV
	{587,1318.9421,2697.4282,10.5447,359.8126,-1,-1}, // Auto (ID: 563) // LV
	{596,1352.3309,2648.6472,10.5403,1.4814,-1,-1}, // Auto (ID: 564) // LV
	{602,1234.7838,2608.4390,10.6264,289.6033,-1,-1}, // Auto (ID: 565) // LV
	{603,1282.7327,2545.9399,10.6583,275.2872,-1,-1}, // Auto (ID: 566) // LV
	{400,1366.1104,2577.6953,10.9127,317.8217,-1,-1}, // Auto (ID: 567) // LV
	{402,1519.7632,2577.3657,10.6521,336.3757,-1,-1}, // Auto (ID: 568) // LV
	{405,1608.6018,2602.4893,10.7023,180.1454,-1,-1}, // Auto (ID: 569) // LV
	{405,1566.6718,2668.0916,10.6914,319.0370,-1,-1}, // Auto (ID: 570) // LV
	{411,1765.1805,2727.4441,10.5630,234.1037,-1,-1}, // Auto (ID: 571) // LV
	{417,1766.9235,2773.6372,10.9303,180.4010,-1,-1}, // Auto (ID: 572) // LV
	{420,1944.3069,2729.9331,10.6062,12.3327,-1,-1}, // Auto (ID: 573) // LV
	{424,2011.8755,2754.3108,10.6008,167.6628,-1,-1}, // Auto (ID: 574) // LV
	{429,2142.6919,2809.8560,10.5000,86.1057,-1,-1}, // Auto (ID: 575) // LV
	{431,2212.9832,2745.1472,10.9320,335.9179,-1,-1}, // Auto (ID: 576) // LV
	{444,2308.5173,2804.4436,11.1916,185.8002,-1,-1}, // Auto (ID: 577) // LV
	{444,2374.3816,2813.4070,11.1916,178.2323,-1,-1}, // Auto (ID: 578) // LV
 	{400,1923.4089,2435.1367,10.9127,179.0887,-1,-1}, // Auto (ID: 581) // LV
	{603,2009.2665,2438.6917,10.6579,91.8762,-1,-1}, // Auto (ID: 582) // LV
	{602,2008.1819,2468.8538,10.6263,91.9030,-1,-1}, // Auto (ID: 583) // LV
	{596,2050.1165,2469.6194,10.5423,359.9953,-1,-1}, // Auto (ID: 584) // LV
	{587,2122.7622,2469.0396,10.5478,359.8091,-1,-1}, // Auto (ID: 585) // LV
	{581,2143.1936,2468.8887,10.4175,359.5596,-1,-1}, // Auto (ID: 586) // LV
	{599,2278.3354,2475.8408,11.0095,178.9711,-1,-1}, // Auto (ID: 587) // LV
	{598,2256.6323,2476.8999,10.5670,176.9950,-1,-1}, // Auto (ID: 588) // LV
	{597,2273.5149,2443.9514,10.5892,0.0671,-1,-1}, // Auto (ID: 589) // LV
	{587,1908.7202,2303.4800,10.5486,85.6297,-1,-1}, // Auto (ID: 590) // LV
	{579,1886.6208,2257.0432,10.7602,175.0734,-1,-1}, // Auto (ID: 591) // LV
	{573,2059.3499,2208.4658,11.4702,0.6970,-1,-1}, // Auto (ID: 592) // LV
	{562,1912.1975,2149.1558,10.4800,88.6867,-1,-1}, // Auto (ID: 593) // LV
	{559,1902.7151,2119.4878,10.4766,356.9144,-1,-1}, // Auto (ID: 594) // LV
	{561,1905.9391,2085.3220,10.6334,91.7509,-1,-1}, // Auto (ID: 595) // LV
	{560,2103.2363,2042.8938,10.5251,88.2493,-1,-1}, // Auto (ID: 596) // LV
	{562,2103.3069,2076.1255,10.4796,93.1118,-1,-1}, // Auto (ID: 597) // LV
	{554,2119.1797,2155.3811,10.7600,178.2039,-1,-1}, // Auto (ID: 598) // LV
	{541,2119.4954,2066.2554,10.2970,180.3228,-1,-1}, // Auto (ID: 599) // LV
	{534,2119.0662,1932.2581,10.3977,180.0511,-1,-1}, // Auto (ID: 600) // LV
	{477,2042.9207,1922.6713,11.9062,178.5264,-1,-1}, // Auto (ID: 601) // LV
	{480,2079.1484,1783.2975,10.4447,154.1233,-1,-1}, // Auto (ID: 602) // LV
	{480,2070.8420,1767.1508,10.4478,152.7331,-1,-1}, // Auto (ID: 603) // LV
	{475,2092.7771,1809.9473,10.4754,153.1527,-1,-1}, // Auto (ID: 604) // LV
	{451,2039.1493,1597.5640,10.3788,181.9713,-1,-1}, // Auto (ID: 605) // LV
	{451,2038.8988,1584.8462,10.3778,179.3356,-1,-1}, // Auto (ID: 606) // LV
	{444,2039.4391,1513.6757,11.0432,180.0291,-1,-1}, // Auto (ID: 607) // LV
	{437,2039.6198,1404.9346,10.8056,180.5550,-1,-1}, // Auto (ID: 608) // LV
	{429,2039.5677,1321.1677,10.3516,181.6999,-1,-1}, // Auto (ID: 609) // LV
	{424,2038.9492,1250.6937,10.4519,179.5542,-1,-1}, // Auto (ID: 610) // LV
	{420,2039.2406,1207.9862,10.4510,177.8705,-1,-1}, // Auto (ID: 611) // LV
	{415,2039.0605,1159.3800,10.4438,179.9244,-1,-1}, // Auto (ID: 612) // LV
	{411,1944.3743,1346.1750,8.8365,180.7022,-1,-1}, // Auto (ID: 613) // LV
	{409,2039.0308,1069.3086,10.4718,178.5853,-1,-1}, // Auto (ID: 614) // LV
	{402,2039.1759,1027.9624,10.5035,180.3284,-1,-1}, // Auto (ID: 615) // LV
	{400,2039.0930,1001.9585,10.7642,181.6197,-1,-1}, // Auto (ID: 616) // LV
	{402,1882.8912,957.9805,10.6519,268.9341,-1,-1}, // Auto (ID: 617) // LV
	{402,1845.6438,1236.0337,10.6594,271.1119,-1,-1}, // Auto (ID: 618) // LV
	{402,1844.8088,1178.5388,10.6729,271.2774,-1,-1}, // Auto (ID: 619) // LV
	{400,2102.8828,937.1990,10.9127,266.8540,-1,-1}, // Auto (ID: 620) // LV
	{603,2162.2849,1009.7399,10.6584,91.4958,-1,-1}, // Auto (ID: 621) // LV
	{602,2132.1482,1025.6594,10.6273,91.3689,-1,-1}, // Auto (ID: 622) // LV
	{598,2138.5227,988.6129,10.5662,1.0051,-1,-1}, // Auto (ID: 623) // LV
	{587,2391.4832,991.0264,10.5486,92.1014,-1,-1}, // Auto (ID: 624) // LV
	{587,2517.3528,935.7255,10.5535,181.0102,-1,-1}, // Auto (ID: 625) // LV
	{602,2460.9824,921.7277,10.6276,269.3363,-1,-1}, // Auto (ID: 626) // LV
	{579,2558.9109,1033.7195,10.7481,181.1569,-1,-1}, // Auto (ID: 627) // LV
	{567,2652.4387,1089.4679,10.6889,90.9619,-1,-1}, // Auto (ID: 628) // LV
	{562,2642.3108,1181.5665,10.4800,178.5183,-1,-1}, // Auto (ID: 629) // LV
	{561,2673.2009,1191.9927,10.6345,181.3839,-1,-1}, // Auto (ID: 630) // LV
	{562,2513.7903,1122.8174,10.4800,269.7218,-1,-1}, // Auto (ID: 631) // LV
	{559,2541.7190,1146.5265,10.4767,88.6497,-1,-1}, // Auto (ID: 632) // LV
	{554,2492.2349,1208.4142,10.9061,180.9725,-1,-1}, // Auto (ID: 633) // LV
	{541,2539.0076,1265.4542,10.4453,160.3399,-1,-1}, // Auto (ID: 634) // LV
	{535,2447.5742,1267.7906,10.5842,0.2621,-1,-1}, // Auto (ID: 635) // LV
	{579,2422.9307,1135.1414,10.6715,181.9284,-1,-1}, // Auto (ID: 636) // LV
	{579,2422.9321,1120.9077,10.6702,179.5626,-1,-1}, // Auto (ID: 637) // LV
	{502,2452.2769,1346.0153,10.7124,359.2310,-1,-1}, // Auto (ID: 638) // LV
	{503,2465.0439,1335.9718,10.7146,178.5906,-1,-1}, // Auto (ID: 639) // LV
	{400,2302.2146,1451.6777,10.9127,270.4311,-1,-1}, // Auto (ID: 640) // LV
	{603,2310.6157,1421.5226,23.4695,181.0644,-1,-1}, // Auto (ID: 641) // LV
	{602,2352.5781,1419.2814,42.6243,89.7630,-1,-1}, // Auto (ID: 642) // LV
	{587,2352.1196,1455.1417,42.5424,88.6588,-1,-1}, // Auto (ID: 643) // LV
	{563,2317.4387,1446.1945,43.5153,1.1057,-1,-1}, // Auto (ID: 644) // LV
	{562,2302.4482,1484.1482,42.4781,268.6696,-1,-1}, // Auto (ID: 645) // LV
	{561,2352.3286,1490.6332,42.6336,89.9929,-1,-1}, // Auto (ID: 646) // LV
	{561,2104.0603,1408.5695,10.6445,2.2311,-1,-1}, // Auto (ID: 647) // LV
	{567,2142.1206,1397.9718,10.7176,178.6413,-1,-1}, // Auto (ID: 648) // LV
	{579,2123.0576,1409.2561,10.7522,0.1670,-1,-1}, // Auto (ID: 649) // LV
	{559,2173.1858,1667.5215,10.4766,59.7869,-1,-1}, // Auto (ID: 650) // LV
	{559,2173.5369,1691.7498,10.4746,106.2892,-1,-1}, // Auto (ID: 651) // LV
	{554,2179.2627,1799.0483,10.9009,179.8574,-1,-1}, // Auto (ID: 652) // LV
	{541,2187.1941,1878.7795,10.4453,180.1422,-1,-1}, // Auto (ID: 653) // LV
	{535,2196.0034,1857.2592,10.5850,1.2613,-1,-1}, // Auto (ID: 654) // LV
	{522,2233.3635,2009.3085,10.3860,3.4425,-1,-1}, // Auto (ID: 655) // LV
	{494,2234.3362,2042.3905,10.7158,89.4486,-1,-1}, // Auto (ID: 656) // LV
	{495,2284.7327,2046.4335,11.1697,88.3199,-1,-1}, // Auto (ID: 657) // LV
	{480,2258.3240,2061.5168,10.5932,181.2921,-1,-1}, // Auto (ID: 658) // LV
	{477,2361.0449,2003.2678,10.4212,2.0077,-1,-1}, // Auto (ID: 659) // LV
	{475,2360.2561,2086.7397,10.4745,1.8052,-1,-1}, // Auto (ID: 660) // LV
	{451,2339.1230,2177.6711,10.4243,181.0041,-1,-1}, // Auto (ID: 661) // LV
	{444,2360.4485,2214.9612,11.0520,3.3923,-1,-1}, // Auto (ID: 662) // LV
	{429,2273.6963,2327.6523,10.5000,269.0871,-1,-1}, // Auto (ID: 663) // LV
	{429,2413.8704,2327.1743,10.5000,270.8905,-1,-1}, // Auto (ID: 664) // LV
	{424,2414.0583,2299.0127,10.6011,270.3839,-1,-1}, // Auto (ID: 665) // LV
	{420,2595.7920,2151.8035,10.5990,358.0331,-1,-1}, // Auto (ID: 666) // LV
	{400,2075.6941,913.0859,8.5909,0.7384,-1,-1}, // Auto (ID: 667) // LV
	{602,2075.9072,948.0523,9.7992,359.3240,-1,-1}, // Auto (ID: 668) // LV
	{603,2075.2837,1009.9357,10.5101,1.5472,-1,-1}, // Auto (ID: 669) // LV
	{599,2075.3909,1078.2031,10.8654,0.3576,-1,-1}, // Auto (ID: 670) // LV
	{599,2075.4390,1094.1086,10.8601,0.3566,-1,-1}, // Auto (ID: 671) // LV
	{587,2075.1809,1158.8722,10.3976,1.1738,-1,-1}, // Auto (ID: 672) // LV
	{579,2075.0483,1245.0372,10.5994,1.8056,-1,-1}, // Auto (ID: 673) // LV
	{573,2074.9988,1298.2078,11.3217,0.3985,-1,-1}, // Auto (ID: 674) // LV
	{567,2075.0464,1387.6366,10.5461,0.4977,-1,-1}, // Auto (ID: 675) // LV
	{562,2075.5933,1473.4690,10.3316,0.8128,-1,-1}, // Auto (ID: 676) // LV
	{561,2075.6326,1559.9949,10.4857,1.2073,-1,-1}, // Auto (ID: 677) // LV
	{554,2075.5437,1621.1005,10.7575,358.9489,-1,-1}, // Auto (ID: 678) // LV
	{541,2075.5059,1673.2665,10.2967,359.4676,-1,-1}, // Auto (ID: 679) // LV
	{534,2155.4607,1917.2766,10.3978,0.4293,-1,-1}, // Auto (ID: 680) // LV
	{522,2185.2744,1979.4097,10.3914,85.3224,-1,-1}, // Auto (ID: 681) // LV
	{522,2154.5818,1989.9274,10.2367,3.6136,-1,-1}, // Auto (ID: 682) // LV
	{514,2154.8982,1957.8542,11.2600,0.5928,-1,-1}, // Auto (ID: 683) // LV
	{503,2172.5295,1997.2028,10.7152,269.6184,-1,-1}, // Auto (ID: 684) // LV
	{500,2153.9834,2112.8030,10.7841,358.3832,-1,-1}, // Auto (ID: 685) // LV
	{495,2154.6987,2188.9827,11.0250,359.8652,-1,-1}, // Auto (ID: 686) // LV
	{562,2486.3972,1418.7130,10.4797,359.4129,-1,-1}, // Auto (ID: 687) // LV
	{562,2612.1533,1400.2998,10.4804,95.2427,-1,-1}, // Auto (ID: 688) // LV
	{559,2611.9143,1423.1117,10.4766,93.5311,-1,-1}, // Auto (ID: 689) // LV
	{554,2399.5823,1630.5410,10.9050,0.6793,-1,-1}, // Auto (ID: 690) // LV
	{541,2364.7573,1659.0729,10.4453,271.8277,-1,-1}, // Auto (ID: 691) // LV
	{522,2389.5376,1658.1003,10.3923,174.0455,-1,-1}, // Auto (ID: 692) // LV
	{503,2397.7356,1675.8136,10.7146,178.6239,-1,-1}, // Auto (ID: 693) // LV
	{502,2472.9041,1676.5941,10.7132,179.2386,-1,-1}, // Auto (ID: 694) // LV
	{500,2510.6877,1667.7654,10.9190,90.7345,-1,-1}, // Auto (ID: 695) // LV
	{495,2485.3235,1658.7672,11.1738,181.3872,-1,-1}, // Auto (ID: 696) // LV
	{494,2461.8220,1629.4918,10.7156,0.1459,-1,-1}, // Auto (ID: 697) // LV
	{490,2599.2249,1681.3528,10.9466,90.5685,-1,-1}, // Auto (ID: 698) // LV
	{480,2603.3362,1789.5363,10.5936,267.2806,-1,-1}, // Auto (ID: 699) // LV
	{477,2591.1577,1812.0546,10.5735,90.1905,-1,-1}, // Auto (ID: 700) // LV
	{475,2603.5059,1859.7488,10.6229,267.7812,-1,-1}, // Auto (ID: 701) // LV
	{470,2629.9082,1881.2034,10.8165,90.2805,-1,-1}, // Auto (ID: 702) // LV
	{451,2630.3674,1756.4694,10.5263,90.9446,-1,-1}, // Auto (ID: 703) // LV
	{444,2628.8962,1686.6470,11.1916,89.9037,-1,-1}, // Auto (ID: 704) // LV
	{437,2543.3755,1835.0986,10.9535,89.8497,-1,-1}, // Auto (ID: 705) // LV
	{429,2563.7966,1881.0818,10.5019,272.8628,-1,-1}, // Auto (ID: 706) // LV
	{424,2587.3745,1966.8784,10.6018,358.1129,-1,-1}, // Auto (ID: 707) // LV
	{420,2786.7432,1976.4226,10.6019,266.3772,-1,-1}, // Auto (ID: 708) // LV
	{420,2786.7720,2005.7379,10.5897,182.3890,-1,-1}, // Auto (ID: 709) // LV
	{411,2787.4622,2196.0876,10.5461,286.8958,-1,-1}, // Auto (ID: 710) // LV
	{411,2805.0239,2247.4250,10.5474,176.6569,-1,-1}, // Auto (ID: 711) // LV
	{409,2880.6169,2435.5112,10.6203,225.7495,-1,-1}, // Auto (ID: 712) // LV
	{406,2793.9922,2389.2312,12.3459,293.8164,-1,-1}, // Auto (ID: 713) // LV
	{405,2788.0437,2431.8391,10.6950,140.0766,-1,-1}, // Auto (ID: 714) // LV
	{402,2865.5020,2338.5896,10.6519,90.5973,-1,-1}, // Auto (ID: 715) // LV
	{400,2841.8831,2357.2415,10.9051,88.9541,-1,-1}, // Auto (ID: 716) // LV
	{400,2826.3401,2330.8994,10.9051,271.6865,-1,-1}, // Auto (ID: 717) // LV
	{602,2879.0986,2375.6147,10.6262,271.7989,-1,-1}, // Auto (ID: 718) // LV
	{603,2805.7976,1342.6234,10.5879,268.2926,-1,-1}, // Auto (ID: 719) // LV
	{602,2764.7939,1278.5344,10.5566,267.3612,-1,-1}, // Auto (ID: 720) // LV
	{579,2852.6946,1358.2184,10.7415,91.0564,-1,-1}, // Auto (ID: 721) // LV
	{520,320.2350,2058.5317,18.3688,147.9100,0,0}, //area 51 by [KS]Zavulon
    {520,297.4626,2059.6431,18.5851,234.9966,0,0}, //
    {520,308.2189,2045.5599,18.6016,1.2369,0,0}, //
    {520,311.1421,2030.7609,18.6261,187.5102,0,0}, //
    {520,301.5955,2018.3245,18.5814,317.0066,0,0}, //
    {520,319.9920,2015.9008,18.5804,30.2577,0,0}, //
    {548,373.1907,1900.0464,19.2488,95.7641,1,1}, //
    {548,376.7159,1918.6742,19.2731,94.5808,1,1}, //
    {548,375.7775,1935.4899,19.3109,90.4864,1,1}, //
    {548,376.4461,1954.3134,19.3243,87.4969,1,1}, //
    {548,377.3526,1971.7832,19.2915,85.5793,1,1}, //
    {601,212.6522,1857.4114,12.8472,2.5733,1,1}, //
    {425,350.1463,1969.2338,18.4215,89.6302,43,0}, //
    {425,351.4236,1954.1605,18.2228,84.5876,43,0}, //
    {425,352.2277,1937.3956,18.2128,90.7654,43,0}, //
    {425,353.0312,1919.7312,18.2223,90.9567,43,0}, //
    {425,352.4249,1900.2153,21.0377,94.0474,43,0}, //
    {432,251.8560,2033.1171,17.6535,264.2352,43,0}, //
    {432,250.4984,2023.9219,17.6600,265.9372,43,0}, //
    {432,250.3306,2014.0669,17.6540,266.1789,43,0}, //
    {432,249.9099,2005.1172,17.6543,264.6068,43,0}, //
    {432,248.5149,1995.4530,17.6552,263.8034,43,0}, //
    {432,248.2420,1986.7666,17.6557,264.6172,43,0}, //
    {432,248.0750,1978.7385,17.6567,267.0634,43,0} //
};

#define VehiclesLS 254
new VehicleInfoLS[VehiclesLS][VehicleInfos] = {
	{492,2488.168701,-1682.798095,13.335395,271.722106,86,1}, // Greenwood (ID: 1) // Groove Street
	{567,2508.157470,-1672.090942,13.378959,349.533935,86,-1}, // Savanna (ID: 2) // Groove Street
	{566,2482.753662,-1655.063964,13.309096,90.323776,86,-1}, // Tahoma (ID: 3) // Groove Street
	{482,2473.407958,-1699.544311,13.519279,359.456268,86,-1}, // Burrito (ID: 4) // Groove Street
	{475,2443.209716,-1642.994262,13.460376,180.146942,86,-1}, // Sabre (ID: 5) // Groove Street
	{566,2227.748779,-1173.421264,25.726562,91.503021,5,-1}, // Tahoma (ID: 6) // Motel Jefferson
	{567,2228.125732,-1162.914916,25.767463,90.980796,5,-1}, // Savanna (ID: 7) // Motel Jefferson
	{468,2217.522460,-1157.238159,25.726562,87.325241,5,-1}, // Sanchez (ID: 8) // Motel Jefferson
	{579,2205.773437,-1177.078857,25.726562,268.538085,5,-1}, // Huntley (ID: 9) // Motel Jefferson
	{482,2217.228515,-1166.083496,25.726562,90.273147,5,-1}, // Burrito (ID: 10) // Motel Jefferson
	{482,2796.360839,-1575.941040,10.927155,271.827880,6,-1}, // Burrito (ID: 11) // East Beach
	{475,2796.361083,-1567.129394,10.927155,269.216796,6,-1}, // Sabre (ID: 12) // East Beach
	{402,2807.477294,-1540.213378,10.921875,180.960388,6,-1}, // Buffalo (ID: 13) // East Beach
	{492,2822.060058,-1562.455444,10.927155,88.180908,6,1}, // Greenwood (ID: 14) // East Beach
	{567,2822.019042,-1553.378662,10.921875,91.137275,6,-1}, // Savanna (ID: 15) // East Beach
	{603,1795.320068,-1934.007202,13.274000,269.756439,51,-1}, // Phoenix (ID: 16) // Unity Station
	{534,1805.043579,-1921.249389,13.264128,0.720035,51,-1}, // Remington (ID: 17) // Unity Station
	{567,1793.350219,-1886.121093,13.269401,89.751121,51,-1}, // Savanna (ID: 18) // Unity Station
	{560,1775.841430,-1914.593750,13.258572,180.302734,51,-1}, // Sultan (ID: 19) // Unity Station
	{482,1838.001953,-1871.373168,13.255450,359.706909,51,-1}, // Burrito (ID: 20) // Unity Station
	{596,1535.970581,-1666.971801,13.188262,359.291046,-1,0}, // LSPD Police Car (ID: 21) // LSPD
	{596,1535.822998,-1678.474365,13.189436,359.291046,-1,0}, // LSPD Police Car (ID: 22) // LSPD
	{487,1561.646850,-1614.772460,13.559510,91.630447,0,1}, // Maverick (ID: 23) // LSPD
	{523,1601.414672,-1688.026367,5.696791,90.164779,0,-1}, // HPV1000 (ID: 24) // LSPD
	{523,1601.492065,-1691.986816,5.696719,91.491439,0,-1}, // HPV1000 (ID: 25) // LSPD
	{596,1587.453979,-1710.865600,5.695763,358.165405,-1,0}, // LSPD Police Car (ID: 26) // LSPD
	{596,1574.501342,-1710.236572,5.695737,359.649810,-1,0}, // LSPD Police Car (ID: 27) // LSPD
	{490,1530.038940,-1683.801269,5.697155,268.263702,0,-1}, // FBI Rancher (ID: 28) // LSPD
	{490,1545.517456,-1667.839477,5.694042,88.184928,0,-1}, // FBI Rancher (ID: 29) // LSPD
	{407,1751.650634,-1454.969604,13.351839,269.315338,-1,-1}, // Firetruck (ID: 30) // LSFD
	{407,1757.273925,-1484.091308,13.347614,247.498703,-1,-1}, // Firetruck (ID: 31) // LSFD
	{416,2020.521728,-1414.153808,16.797670,89.666770,-1,-1}, // Ambulance (ID: 32) // Hospital
	{416,2033.666503,-1431.295166,16.902194,358.661865,-1,-1}, // Ambulance (ID: 33) // Hospital
	{409,1244.272827,-2025.900878,59.659931,180.460601,0,0}, // Stretch (ID: 34) // Verdant Bluffs
	{490,1257.755371,-2010.788085,59.266197,180.460601,0,-1}, // FBI Rancher (ID: 35) // Verdant Bluffs
	{490,1267.860351,-2010.542358,58.977474,180.460601,0,-1}, // FBI Rancher (ID: 36) // Verdant Bluffs
	{426,1276.659301,-2030.210449,58.771591,89.707191,0,-1}, // Premier (ID: 37) // Verdant Bluffs
	{482,1276.537597,-2039.880126,58.810909,90.653999,0,-1}, // Burrito (ID: 38) // Verdant Bluffs
	{500,314.998229,-1788.702636,4.348239,180.305267,61,-1}, // Mesa (ID: 39) // Santa Maria Beach
	{587,324.641326,-1789.121826,4.501376,180.305267,61,-1}, // Euros (ID: 40) // Santa Maria Beach
	{405,347.111938,-1809.621582,4.234993,0.546290,61,-1}, // Sentinel (ID: 41) // Santa Maria Beach
	{542,334.075195,-1808.767578,4.221151,0.546290,61,-1}, // Clover (ID: 42) // Santa Maria Beach
	{579,321.201171,-1808.881347,4.208554,0.546290,61,-1}, // Huntley (ID: 43) // Santa Maria Beach
	{567,204.645416,-1444.406616,12.815665,318.328063,29,-1}, // Savanna (ID: 44) // Rodeo
	{475,200.009826,-1440.660522,12.803405,318.328063,29,-1}, // Sabre (ID: 45) // Rodeo
	{560,211.957931,-1423.395996,12.980006,134.051132,29,-1}, // Sultan (ID: 46) // Rodeo
	{405,218.385528,-1429.711669,12.996314,134.051132,29,-1}, // Sentinel (ID: 47) // Rodeo
	{521,214.204193,-1439.008666,12.926919,226.178039,29,-1}, // FCR-900 (ID: 48) // Rodeo
	{559,1311.380981,-856.143981,39.300998,177.522262,3,-1}, // Jester (ID: 49) // Mulholland
	{560,1321.721557,-856.712707,39.298252,177.522262,3,-1}, // Sultan (ID: 50) // Mulholland
	{506,1330.086059,-881.975463,39.298839,177.522262,3,-1}, // Super GT (ID: 51) // Mulholland
	{562,1319.317626,-873.059509,39.299736,177.522262,3,-1}, // Elegy (ID: 52) // Mulholland
	{522,1309.148193,-872.496093,39.298271,177.522262,3,-1}, // NRG500 (ID: 53) // Mulholland
	{492,871.714355,-1535.169677,13.214927,271.655426,55,-1}, // Greenwood (ID: 54) // Marina
	{603,884.036315,-1523.192993,13.215357,89.182685,55,-1}, // Phoenix (ID: 55) // Marina
	{482,855.193786,-1528.053588,13.013707,266.415924,55,-1}, // Burrito (ID: 56) // Marina
	{535,857.273193,-1512.742797,13.087572,266.415924,55,-1}, // Slamvan (ID: 57) // Marina
	{411,864.314453,-1500.947631,13.224195,177.197021,55,-1}, // Infernus (ID: 58) // Marina
	{514,2747.800048,-2465.335693,13.429963,269.006835,-1,-1}, // Tanker (ID: 59) // Docks
	{514,2748.372070,-2443.649658,13.425960,269.006835,-1,-1}, // Tanker (ID: 60) // Docks
	{406,2762.364990,-2394.942871,13.412092,177.454864,-1,-1}, // Dumper (ID: 61) // Docks
	{406,2779.589843,-2437.101074,13.414171,91.006835,-1,-1}, // Dumper (ID: 62) // Docks
	{487,2795.082763,-2545.983642,13.412330,177.454864,-1,-1}, // Maverick (ID: 63) // Docks
	{535,2785.703613,-1994.749389,13.163056,94.267616,-1,-1}, // Slamvan (ID: 64) // Playa Del Seville
	{566,2685.203857,-2017.712280,13.328207,358.753265,-1,-1}, // Tahoma (ID: 65) // Playa Del Seville
	{534,2662.252197,-2000.307250,13.165456,88.463493,-1,-1}, // Remington (ID: 66) // Playa Del Seville
	{567,2652.270019,-2035.403930,13.331976,41.777493,-1,-1}, // Savanna (ID: 67) // Playa Del Seville
	{444,2797.901855,-1875.848999,9.649276,359.544311,-1,-1}, // Monster (ID: 68) // Stadium
	{444,2787.847412,-1875.416748,9.610875,359.544311,-1,-1}, // Monster (ID: 69) // Stadium
	{444,2777.813476,-1875.198242,9.572721,359.544311,-1,-1}, // Monster (ID: 70) // Stadium
	{444,2767.774414,-1875.595703,9.523494,359.544311,-1,-1}, // Monster (ID: 71) // Stadium
	{494,2771.998291,-1842.478271,9.545600,200.137451,-1,-1}, // Hotring (ID: 72) // Stadium
	{494,2762.750244,-1846.010620,9.512990,200.137451,-1,-1}, // Hotring (ID: 73) // Stadium
	{494,2753.314941,-1849.223632,9.472146,199.192810,-1,-1}, // Hotring (ID: 74) // Stadium
	{494,2741.720947,-1851.832397,9.421898,179.380416,-1,-1}, // Hotring (ID: 75) // Stadium
	{487,1544.362426,-1353.175292,329.474548,90.522239,-1,-1}, // Maverick (ID: 76) // Highest Building
	{542,1013.543395,-1020.710021,31.762334,178.791854,-1,-1}, // Clover (ID: 77) // Temple
	{541,1096.994140,-1026.650512,31.849119,178.864196,-1,-1}, // Bullet (ID: 78) // Temple
	{429,1040.908813,-1052.341064,31.362176,0.864196,-1,-1}, // Banshee (ID: 79) // Temple
	{415,1028.227661,-1052.463989,31.307344,0.864196,-1,-1}, // Cheetah (ID: 80) // Temple
	{451,1016.122314,-1052.256835,31.022838,0.864196,-1,-1}, // Turismo (ID: 81) // Temple
	{480,1003.994445,-1052.958862,30.744747,0.864196,-1,-1}, // Comet (ID: 82) // Temple
	{506,989.683654,-919.843505,41.839294,181.591979,-1,-1}, // Super GT (ID: 83) // Temple
	{477,1000.786499,-1085.005737,23.489233,178.768478,-1,-1}, // ZR350 (ID: 84) // Temple
	{446,731.653076,-1497.972045,4.631143,181.861129,-1,-1}, // Squalo (ID: 85) // Market
	{487,1989.280395,-2249.075439,13.723354,90.048965,-1,-1}, // Maverick (ID: 86) // Airport
	{487,1989.216430,-2315.605712,13.724207,90.048965,-1,-1}, // Maverick (ID: 87) // Airport
	{487,1989.617675,-2382.604003,13.722428,90.048965,-1,-1}, // Maverick (ID: 88) // Airport
	{476,1823.287597,-2620.903564,13.546875,6.532232,-1,-1}, // Rustler (ID: 89) // Airport
	{476,1753.408813,-2621.539306,13.546875,2.522825,-1,-1}, // Rustler (ID: 90) // Airport
	{476,1682.046386,-2621.489501,13.546875,1.309966,-1,-1}, // Rustler (ID: 91) // Airport
	{476,1616.716186,-2623.020751,13.546875,2.691160,-1,-1}, // Rustler (ID: 92) // Airport
	{513,1565.795776,-2629.644531,13.546875,357.991119,-1,-1}, // Stuntplane (ID: 93) // Airport
	{513,1544.431884,-2628.521240,13.546875,357.991119,-1,-1}, // Stuntplane (ID: 94) // Airport
	{513,1526.430541,-2627.558349,13.546875,357.991119,-1,-1}, // Stuntplane (ID: 95) // Airport
	{513,1507.414672,-2626.932373,13.546875,357.991119,-1,-1}, // Stuntplane (ID: 96) // Airport
	{437,1665.962768,-2313.818847,13.329627,90.613891,-1,-1}, // Coach (ID: 97) // Airport
	{437,1699.231079,-2313.866455,13.329858,90.613891,-1,-1}, // Coach (ID: 98) // Airport
	{420,1560.797851,-2318.739501,13.416219,90.050659,-1,-1}, // Taxi (ID: 99) // Airport
	{500,1542.901000,-2361.018066,13.425674,359.819000,-1,-1}, // Mesa (ID: 100) // Airport
	{559,1454.505981,-2348.327636,13.414303,359.819000,-1,-1}, // Jester (ID: 101) // Airport
	{534,1404.678100,-2331.296142,13.419953,359.819000,-1,-1}, // Remington (ID: 102) // Airport
	{463,1365.557006,-2326.746093,13.417978,90.989105,-1,-1}, // Freeway (ID: 103) // Airport
	{542,1364.885009,-2246.154296,13.417449,269.052032,-1,-1}, // Clover (ID: 104) // Airport
	{475,1388.229125,-2225.669921,13.417157,0.328545,-1,-1}, // Sabre (ID: 105) // Airport
	{470,1408.144165,-2208.654785,13.409720,179.281478,-1,-1}, // Patriot (ID: 106) // Airport
	{451,1451.273437,-2224.511230,13.415595,179.281478,-1,-1}, // Turismo (ID: 107) // Airport
	{522,1512.114746,-2211.639404,13.422736,359.647491,-1,-1}, // NRG500 (ID: 108) // Airport
	{426,1560.190063,-2254.181152,13.416652,271.015991,-1,-1}, // Premier (ID: 109) // Airport
	{415,1681.843139,-2259.461181,13.300088,269.898681,-1,-1}, // Cheetah (ID: 110) // Airport
	{562,1951.140136,-2205.027099,13.417691,269.319335,-1,-1}, // Elegy (ID: 111) // Airport
	{468,1969.294189,-2184.720703,13.414156,359.800323,-1,-1}, // Sanchez (ID: 112) // Airport
	{510,1886.371582,-1360.628173,19.140625,90.731697,-1,-1}, // Mountain Bike (ID: 113) // Park
	{510,1886.252197,-1364.958374,19.140625,88.120559,-1,-1}, // Mountain Bike (ID: 114) // Park
	{510,1869.581054,-1364.902465,19.140625,268.996643,-1,-1}, // Mountain Bike (ID: 115) // Park
	{510,1869.607055,-1360.417968,19.140625,268.474365,-1,-1}, // Mountain Bike (ID: 116) // Park
	{510,1952.080322,-1380.445678,24.148437,359.864044,-1,-1}, // Mountain Bike (ID: 117) // Park
	{510,1956.610229,-1380.303588,24.148437,359.341827,-1,-1}, // Mountain Bike (ID: 118) // Park
	{510,1956.630249,-1363.743652,24.148437,178.987945,-1,-1}, // Mountain Bike (ID: 119) // Park
	{510,1952.154418,-1363.976928,24.148437,177.943496,-1,-1}, // Mountain Bike (ID: 120) // Park
	{510,1921.441406,-1418.123291,16.359375,93.157211,-1,-1}, // Mountain Bike (ID: 121) // Park
	{510,1913.456542,-1434.901855,16.366991,270.714477,-1,-1}, // Mountain Bike (ID: 122) // Park
	{411,1135.481201,-1466.869873,15.545242,40.920494,-1,-1}, // Infernus (ID: 123) // Verona Mall
	{415,1135.481201,-1461.869873,15.545242,40.920494,-1,-1}, // Cheetah (ID: 124) // Verona Mall
	{429,1135.481201,-1456.869873,15.545242,40.920494,-1,-1}, // Banshee (ID: 125) // Verona Mall
	{451,1135.481201,-1451.869873,15.545242,40.920494,-1,-1}, // Turismo (ID: 126) // Verona Mall
	{506,1135.481201,-1446.869873,15.545242,40.920494,-1,-1}, // Super GT (ID: 127) // Verona Mall
	{541,1135.481201,-1441.869873,15.545242,40.920494,-1,-1}, // Bullet (ID: 128) // Verona Mall
	{411,1122.481201,-1466.869873,15.545242,310.920494,-1,-1}, // Infernus (ID: 129) // Verona Mall
	{415,1122.481201,-1461.869873,15.545242,310.920494,-1,-1}, // Cheetah (ID: 130) // Verona Mall
	{429,1122.481201,-1456.869873,15.545242,310.920494,-1,-1}, // Banshee (ID: 131) // Verona Mall
	{451,1122.481201,-1451.869873,15.545242,310.920494,-1,-1}, // Turismo (ID: 132) // Verona Mall
	{506,1122.481201,-1446.869873,15.545242,310.920494,-1,-1}, // Super GT (ID: 133) // Verona Mall
	{541,1122.481201,-1441.869873,15.545242,310.920494,-1,-1}, // Bullet (ID: 134) // Verona Mall
	{409,668.889770,-1294.412719,13.242489,0.779876,-1,-1}, // Stretch (ID: 135) // Golf Club
	{409,1825.435424,-1682.812744,13.162638,0.978817,-1,-1}, // Stretch (ID: 136) // Alhambra Club
	{542,2416.276855,-1718.419677,13.529325,179.012817,-1,-1}, // Clover (ID: 137) // Groove Street
	{579,2497.724853,-1750.778442,13.233366,19.892271,-1,-1}, // Huntley (ID: 138) // Groove Street
	{475,2659.429687,-1425.874877,30.253877,0.312046,-1,-1}, // Sabre (ID: 139) // Eastside
	{402,2603.372314,-1250.774536,47.516540,90.312046,-1,-1}, // Buffalo (ID: 140) // Eastside
	{506,2430.125244,-1242.370727,24.037115,180.653350,-1,-1}, // Super GT (ID: 141) // Pig Pen
	{405,2270.338623,-1433.710205,23.612556,354.944854,-1,-1}, // Sentinel (ID: 142) // Eastside
	{534,2422.818115,-1106.193359,41.077373,4.864102,-1,-1}, // Remington (ID: 143) // Eastside
	{463,2751.363769,-1106.430053,69.360404,358.515625,-1,-1}, // Freeway (ID: 144) // Eastside
	{500,2743.434082,-1073.248291,69.324546,42.831970,-1,-1}, // Mesa (ID: 145) // Eastside
	{470,2816.528320,-1184.118408,25.115844,269.205902,-1,-1}, // Patriot (ID: 146) // Eastside
	{521,2390.796386,-1494.082519,23.537887,270.671630,-1,-1}, // FCR-900 (ID: 147) // Eastside Cluckin' Bell
	{420,2301.064697,-1638.187255,14.355358,204.079620,-1,-1}, // Taxi (ID: 148) // Groove Street Bar
	{429,2386.544921,-1927.515991,13.087308,1.484918,-1,-1}, // Banshee (ID: 149) // Ganton Cluckin' Bell
	{492,2502.870117,-2005.957397,12.985747,88.768928,-1,-1}, // Greenwood (ID: 150) // Willowfield
	{514,2437.250732,-2107.854980,13.254782,356.197235,-1,-1}, // Tanker (ID: 151) // Willowfield
	{468,2265.018798,-2122.640380,13.251161,42.138710,-1,-1}, // Sanchez (ID: 152) // Docks
	{603,1931.903564,-2151.721923,13.254512,179.011871,-1,-1}, // Phoenix (ID: 153) // Airport
	{415,1883.562866,-2022.473510,13.094923,179.906265,-1,-1}, // Cheetah (ID: 154) // El Corona
	{470,1922.774658,-1792.124389,13.087321,271.566925,-1,-1}, // Patriot (ID: 155) // El Corona
	{426,2095.775390,-1797.090087,13.165884,89.055381,-1,-1}, // Premier (ID: 156) // Idlewood
	{522,2159.146484,-1800.948608,13.153849,270.173706,-1,-1}, // NRG500 (ID: 157) // Idlewood
	{477,2092.460449,-1576.368774,13.005808,178.178710,-1,-1}, // ZR350 (ID: 158) // Idlewood
	{566,1825.292602,-1655.640380,13.163235,358.728363,-1,-1}, // Tahoma (ID: 159) // Alhambra Club
	{522,1825.332519,-1709.678344,13.163582,358.728363,-1,-1}, // NRG500 (ID: 160) // Alhambra Club
	{490,1125.806030,-1744.515014,13.178814,270.739562,0,-1}, // FBI Rancher (ID: 161) // Conference Center
	{405,1144.784057,-1744.501586,13.179642,270.739562,0,-1}, // Sentinel (ID: 162) // Conference Center
	{411,1080.781005,-1763.776489,13.152679,269.337951,-1,-1}, // Infernus (ID: 163) // Conference Center
	{506,1062.199218,-1743.167846,13.246815,90.171699,-1,-1}, // Super GT (ID: 164) // Conference Center
	{559,888.122985,-1669.256958,13.326845,179.932769,-1,-1}, // Jester (ID: 165) // Verona Beach
	{480,841.968078,-1802.136230,13.074001,0.501242,-1,-1}, // Comet (ID: 166) // Verona Beach Peer
	{579,639.531122,-1707.006704,14.369411,35302.261731,-1,-1}, // Huntley (ID: 167) // Verona Beach
	{522,447.087585,-1733.396362,9.526784,309.447814,-1,-1}, // NRG500 (ID: 168) // Verona Beach
	{541,107.669761,-1555.394042,7.145474,250.447814,-1,-1}, // Bullet (ID: 169) // Rodeo
	{429,336.078460,-1296.101684,54.005210,25.510961,-1,-1}, // Banshee (ID: 170) // Rodeo
	{500,404.925323,-1154.457763,77.213508,147.510961,-1,-1}, // Mesa (ID: 171) // Richman
	{562,564.611083,-1065.602050,73.474952,31.700830,-1,-1}, // Elegy (ID: 172) // Richman
	{405,1275.730224,-1558.857421,13.342744,90.362113,-1,-1}, // Sentinel (ID: 173) // Market
	{420,1304.286865,-1137.348999,23.438859,92.285606,-1,-1}, // Taxi (ID: 174) // Market
	{560,974.311645,-1304.160278,13.164890,179.460983,-1,-1}, // Sultan (ID: 175) // Market
	{579,746.687683,-1344.158081,13.300282,270.392517,-1,-1}, // Huntley (ID: 176) // Vinewood
	{480,834.464599,-925.766235,55.036350,242.148605,-1,-1}, // Comet (ID: 177) // Vinewood
	{587,724.647583,-994.253356,52.410949,59.031322,-1,-1}, // Euros (ID: 178) // Vinewood
	{470,792.086608,-849.858276,60.419754,171.635818,-1,-1}, // Patriot (ID: 179) // Vinewood
	{451,891.814514,-714.456726,108.325859,243.634704,-1,-1}, // Turismo (ID: 180) // Vinewood
	{415,1105.364379,-642.652221,112.454177,43.034236,-1,-1}, // Cheetah (ID: 181) // Vinewood
	{477,1358.613159,-615.489318,108.912948,76.262275,-1,-1}, // ZR350 (ID: 182) // Vinewood
	{429,1248.067993,-781.312622,90.462387,359.262275,-1,-1}, // Banshee (ID: 183) // Maddog's House
	{562,1251.299804,-812.692932,83.927108,141.262275,-1,-1}, // Elegy (ID: 184) // Maddog's House
	{487,1291.206298,-788.211303,96.460937,179.734359,-1,-1}, // Maverick (ID: 185) // Maddog's House
	{411,1524.090454,-882.923156,60.904850,49.207355,-1,-1}, // Infernus (ID: 186) // Vinewood
	{521,1685.356079,-1035.566650,23.690450,180.704605,-1,-1}, // FCR-900 (ID: 187) // Mulholland Intersection
	{587,1721.432983,-1007.263793,23.696136,352.521728,-1,-1}, // Euros (ID: 188) // Mulholland Intersection
	{541,1757.339355,-1037.625732,23.743011,179.695190,-1,-1}, // Bullet (ID: 189) // Mulholland Intersection
	{482,1788.991821,-1060.637084,23.744018,358.440948,-1,-1}, // Burrito (ID: 190) // Mulholland Intersection
	{468,1739.945434,-1084.709228,23.741813,358.440948,-1,-1}, // Sanchez (ID: 191) // Mulholland Intersection
	{470,1695.894042,-1069.324340,23.689058,358.440948,-1,-1}, // Patriot (ID: 192) // Mulholland Intersection
	{567,1658.602539,-1106.834716,23.690155,88.377090,-1,-1}, // Savanna (ID: 193) // Mulholland Intersection
	{429,1617.230590,-1128.288452,23.686874,88.377090,-1,-1}, // Banshee (ID: 194) // Mulholland Intersection
	{402,1581.666015,-1043.707275,23.688972,127.121681,-1,-1}, // Buffalo (ID: 195) // Mulholland Intersection
	{534,1910.453857,-1120.688232,25.493597,180.253845,-1,-1}, // Remington (ID: 196) // Park
	{426,1965.313110,-1210.967895,25.215663,185.093856,-1,-1}, // Premier (ID: 197) // Park
	{559,2084.050292,-1342.558471,23.768108,90.043258,-1,-1}, // Jester (ID: 198) // Mulholland
	{522,1585.928222,-1011.110290,23.687934,6.290105,-1,-1}, // NRG500 (ID: 199) // Mulholland Intersection
	{603,1636.306152,-1047.303100,23.687259,179.662826,-1,-1}, // Phoenix (ID: 200) // Mulholland Intersection
	{475,1431.105503,-1028.763811,23.547245,89.120421,-1,-1}, // Sabre (ID: 201) // Mulholland
	{492,1215.208129,-875.502014,42.690128,189.749923,-1,-1}, // Greenwood (ID: 202) // Vinewood
	{514,1147.334960,-1238.864746,15.860088,180.982284,-1,-1}, // Tanker (ID: 203) // Market
	{451,1282.760864,-1355.385253,13.253620,0.298043,-1,-1}, // Turismo (ID: 204) // Market
	{559,1560.973754,-1308.880615,16.777351,270.087646,-1,-1}, // Jester (ID: 205) // Highest Building
	{402,1533.991333,-1308.772094,15.604850,270.087646,-1,-1}, // Buffalo (ID: 206) // Highest Building
	{542,1730.300903,-1277.318481,13.432171,139.551971,-1,-1}, // Clover (ID: 207) // Near Park
	{562,2102.487548,-982.701477,53.715827,74.013938,-1,-1}, // Elegy (ID: 208) // Eastside
	{405,769.467895,-1128.637329,23.845144,218.737091,-1,-1}, // Sentinel (ID: 209) // Richman
	{521,872.521728,-1339.831665,13.422805,359.602630,-1,-1}, // FCR-900 (ID: 210) // Market
	{587,746.151428,-1647.853637,5.130365,179.769378,-1,-1}, // Euros (ID: 211) // Market
	{477,236.171966,-1566.026611,32.787525,163.647262,-1,-1}, // ZR350 (ID: 212) // Rodeo
	{426,398.119567,-1577.055664,27.922294,91.100753,-1,-1}, // Premier (ID: 213) // Rodeo
	{463,546.459821,-1477.241801,14.222844,3.921021,-1,-1}, // Freeway (ID: 214) // Rodeo
	{409,487.772308,-1515.493041,19.883850,5.185674,-1,-1}, // Stretch (ID: 215) // Rodeo
	{411,482.113616,-1489.037719,19.645090,184.543838,-1,-1}, // Infernus (ID: 216) // Rodeo
	{522,511.460700,-1597.633950,15.268744,270.319421,-1,-1}, // NRG500 (ID: 217) // Rodeo
	{415,609.892333,-1511.540771,14.555418,269.814208,-1,-1}, // Cheetah (ID: 218) // Rodeo
	{402,1269.080688,-1796.741088,13.186159,179.752624,-1,-1}, // Buffalo (ID: 219) // Conference Center
	{535,1034.401000,-2284.181396,12.799115,204.966705,-1,-1}, // Slamvan (ID: 220) // Near Airport
	{470,377.743591,-2034.954956,7.367589,43.895828,-1,-1}, // Patriot (ID: 221) // Santa Maria Beach
	{487,395.903717,-1858.933471,13.601562,0.681233,-1,-1}, // Maverick (ID: 222) // Santa Maria Beach
	{560,2337.197509,-1759.043457,13.331455,358.909698,-1,-1}, // Sultan (ID: 223) // Groove Street
	{480,2232.150146,-1937.669311,13.322902,88.823371,-1,-1}, // Comet (ID: 224) // Willowfield
	{587,2092.116455,-2094.257568,13.327116,177.526306,-1,-1}, // Euros (ID: 225) // Willowfield
	{603,1747.708129,-2099.114990,13.328202,179.969940,-1,-1}, // Phoenix (ID: 226) // Near Airport
	{541,1636.577148,-1902.174194,13.334104,300.834533,-1,-1}, // Bullet (ID: 227) // Verdant Bluffs
	{566,1373.253051,-1889.279663,13.279490,359.301208,-1,-1}, // Tahoma (ID: 228) // Verdant Bluffs
	{477,1025.350097,-1550.914672,13.332073,180.034439,-1,-1}, // ZR350 (ID: 229) // Market
	{463,441.789764,-1295.604858,14.972719,203.356765,-1,-1}, // Freeway (ID: 230) // Richman
	{480,399.930694,-1432.127807,32.826747,217.363891,-1,-1}, // Comet (ID: 231) // Rodeo
	{560,666.261657,-1418.682373,13.946446,357.971557,-1,-1}, // Sultan (ID: 232) // Market
	{420,996.153625,-1438.099121,13.328618,357.971557,-1,-1}, // Taxi (ID: 233) // Market
	{603,1459.093627,-1502.755615,13.331052,38.762462,-1,-1}, // Phoenix (ID: 234) // Market
	{480,1514.192749,-1462.814819,9.281811,181.656448,-1,-1}, // Comet (ID: 235) // Downtown
	{468,1523.681762,-1464.850219,9.283031,181.656448,-1,-1}, // Sanchez (ID: 236) // Downtown
	{521,1648.613159,-1343.982177,17.218912,181.656448,-1,-1}, // FCR-900 (ID: 237) // Downtown
	{477,2133.300537,-1132.668334,25.456342,44.821918,-1,-1}, // ZR350 (ID: 238) // Jefferson
	{463,2120.306640,-1136.523803,25.012439,306.459991,-1,-1}, // Freeway (ID: 239) // Jefferson
	{468,2148.018066,-1152.891723,23.724176,269.350891,-1,-1}, // Sanchez (ID: 240) // Jefferson
	{541,2161.433105,-1182.537719,23.601108,269.350891,-1,-1}, // Bullet (ID: 241) // Jefferson
	{420,1363.211425,-1643.393554,13.164815,269.703430,-1,-1}, // Taxi (ID: 242) // Commerce
	{592,2104.534221,-2450.372304,14.741810,127.896124,1,1}, // Andromada (ID: 243) // Airport
	{521,2470.294677,-1669.880371,13.096332,191.679702,86,-1}, // FCR-900 (ID: 244) // Groove Street
	{587,2206.342529,-1160.932495,25.512912,270.352844,5,-1}, // Euros (ID: 245) // Motel Jefferson
	{463,2796.455078,-1553.996337,10.704411,268.811889,6,-1}, // Freeway (ID: 246) // East Beach
	{468,1816.051269,-1902.948974,13.314620,178.052764,51,-1}, // Sanchez (ID: 247) // Unity Station
	{522,1250.838623,-2044.338134,59.429252,268.036926,0,-1}, // NRG500 (ID: 248) // Verdant Bluffs
	{487,1193.664428,-2053.663818,69.007812,275.950592,0,0}, // Maverick (ID: 249) // Verdant Bluffs
	{560,337.544464,-1788.788085,4.488074,178.447174,61,-1}, // Sultan (ID: 250) // Santa Maria Beach
	{566,240.217666,-1454.409057,13.280391,312.177062,29,-1}, // Tahoma (ID: 251) // Rodeo
	{480,1331.055786,-857.570800,39.454654,178.864349,3,-1}, // Comet (ID: 252) // Mulholland
	{468,872.113830,-1514.140869,13.259681,180.265335,55,-1}, // Sanchez (ID: 253) // Marina
	{470,893.968200,-1519.364746,12.898312,179.077041,55,-1} // Patriot (ID: 254) // Marina
};

#define VehiclesSF 141
new VehicleInfoSF[VehiclesSF][VehicleInfos] = {
	{476,-1662.5466,-334.0200,14.8614,45.8685,-1,-1}, // Rustler (ID: 255) // AirportSF
	{476,-1610.8314,-282.8324,14.8629,45.4650,-1,-1}, // Rustler (ID: 256) // AirportSF
	{476,-1561.5743,-233.2032,14.8537,45.5518,-1,-1}, // Rustler (ID: 257) // AirportSF
	{592,-1337.5780,-222.2742,15.3408,315.0829,-1,-1}, // Samolet (ID: 258) // AirportSF
	{487,-1185.7042,25.3678,14.3252,44.1463,-1,-1}, // Maverick (ID: 259) // AirportSF
	{487,-1224.0339,-11.2760,14.3251,42.6844,-1,-1}, // Maverick (ID: 260) // AirportSF
	{513,-1353.9696,-23.1772,14.6943,44.0887,-1,-1}, // Stuntplane (ID: 261) // AirportSF
	{513,-1318.5015,12.5643,14.6939,45.6882,-1,-1}, // Stuntplane (ID: 262) // AirportSF
	{437,-1990.6003,157.6368,27.6724,359.4419,-1,-1}, // Coach (ID: 263) // SF Trian
	{437,-1990.9060,121.8997,27.6722,359.3258,-1,-1}, // Coach (ID: 264) // SF Train
	{541,-2032.1864,177.6067,28.4644,272.5220,-1,-1}, // Bullet (ID: 265) // SF Train
	{451,-2085.4763,-83.2973,34.9779,359.0814,-1,-1}, // Turismo (ID: 266) // SF
	{562,-2068.7332,-83.1760,34.8226,0.7436,-1,-1}, // Elegy (ID: 267) // SF
	{567,-2070.5303,15.7971,35.1899,357.5885,-1,-1}, // Savanna (ID: 268) // SF
	{579,-2352.1804,-125.9953,35.2436,359.1839,-1,-1}, // Huntley (ID: 269) // SF
	{522,-2337.4636,-125.4651,34.9101,1.8688,-1,-1}, // NRG500 (ID: 270) // SF
	{490,-2770.0308,-295.1693,7.1680,177.8536,-1,-1}, // FBI Rancher (ID: 271) // Golf Club SF
	{490,-2753.6001,-295.4026,7.1697,180.1243,-1,-1}, // FBI Rancher (ID: 272) // Golf Club SF
	{470,-2674.9280,-275.4244,7.1666,12.1230,-1,-1}, // Hammer (ID: 273) // Golf Club SF
	{457,-2644.5491,-264.3772,7.0723,0.5944,-1,-1}, // Golfer (ID: 274) // Golf Club SF
	{457,-2657.0178,-262.1688,7.0326,17.6564,-1,-1}, // Golfer (ID: 275) // Golf Club SF
	{451,-2686.9417,-251.5957,6.6283,264.1987,-1,-1}, // Turismo (ID: 276) // Golf Club SF
	{457,-2514.9133,-243.5802,38.2063,184.8199,-1,-1}, // Golfer (ID: 277) // Golf Club SF
	{457,-2355.6985,-260.3281,42.7295,40.3968,-1,-1}, // Golfer (ID: 278) // Golf Club SF
	{451,-2467.2771,-257.2869,39.2460,26.8235,-1,-1}, // Turismo (ID: 279) // Golf Club SF
	{451,-2514.2769,-307.8950,39.0062,46.2494,-1,-1}, // Turismo (ID: 280) // Golf Club SF
	{451,-2609.0447,-306.6598,22.7947,326.8587,-1,-1}, // Turismo (ID: 281) // Golf Club SF
	{451,-2611.3337,-243.3176,18.8354,217.1848,-1,-1}, // Turismo (ID: 282) // Golf Club SF
	{475,-2796.5405,-183.7558,6.9910,90.9762,-1,-1}, // Auto (ID: 283) // Home SF
	{451,-2796.2756,-148.9537,6.8939,88.5013,-1,-1}, // Auto (ID: 284) // Home SF
	{411,-2796.3958,-85.8631,6.9146,90.8383,-1,-1}, // Auto (ID: 285) // Home SF
	{402,-2796.6350,-23.8292,7.0229,89.1405,-1,-1}, // Auto (ID: 286) // Home SF
	{400,-2796.8982,87.5337,7.2799,91.4510,-1,-1}, // Auto (ID: 287) // Home SF
	{603,-2717.9612,-37.9379,4.1808,213.9554,-1,-1}, // Auto (ID: 288) // Home SF
	{602,-2694.1758,-154.4725,4.1445,88.7058,-1,-1}, // Auto (ID: 289) // Home SF
	{579,-2694.2434,-91.8341,4.2681,90.0252,-1,-1}, // Auto (ID: 290) // Home SF
	{562,-2694.1396,117.5651,3.9942,90.1916,-1,-1}, // Auto (ID: 291) // Home SF
	{559,-2690.2205,205.5602,3.9922,1.3575,-1,-1}, // Auto (ID: 292) // Home SF
	{560,-2681.5474,268.0838,4.0406,359.3733,-1,-1}, // Auto (ID: 293) // Home SF
	{561,-2616.0522,132.3034,4.1541,235.7643,-1,-1}, // Auto (ID: 294) // Home SF
	{541,-2615.9353,70.3793,3.9609,270.8502,-1,-1}, // Auto (ID: 295) // Home SF
	{534,-2615.8462,-108.7904,4.0603,265.2466,-1,-1}, // Auto (ID: 296) // Home SF
	{522,-2614.8301,-191.4344,3.8937,270.2018,-1,-1}, // Auto (ID: 297) // Home SF
	{562,-1991.1307,247.2974,34.8316,262.6638,-1,-1}, // Elegy (ID: 298) // Wang Cars
	{562,-1989.6851,257.5072,34.8338,261.8989,-1,-1}, // Elegy (ID: 299) // Wang Cars
	{561,-1987.6996,267.6765,34.9926,261.2628,-1,-1}, // Auto (ID: 300) // Wang Cars
	{560,-1984.8319,305.1095,34.8769,262.4925,-1,-1}, // Sultan (ID: 301) // Wang Cars
	{559,-1952.0425,260.0181,35.1267,70.0956,-1,-1}, // Jester (ID: 302) // Wang Cars
	{541,-1949.2062,270.1539,35.0965,112.2325,-1,-1}, // Bullet (ID: 303) // Wang Cars
	{451,-1958.3472,296.4760,35.1745,130.6362,-1,-1}, // Turismo (ID: 304) // Wang Cars
	{411,-2274.8921,-123.9524,35.0474,268.5944,-1,-1}, // Auto (ID: 305) // SF
	{402,-2267.6453,73.4996,34.9957,268.9467,-1,-1}, // Auto (ID: 306) // SF
	{400,-2265.6475,109.3362,35.2641,268.8883,-1,-1}, // Auto (ID: 307) // SF
	{603,-2266.2471,141.1797,34.9989,269.7547,-1,-1}, // Auto (ID: 308) // SF
	{602,-2265.5610,200.6624,34.9715,270.5835,-1,-1}, // Auto (ID: 309) // SF
	{579,-2095.4263,187.1508,34.9823,338.8124,-1,-1}, // Auto (ID: 310) // SF
	{579,-2116.3174,186.2632,34.5431,325.8177,-1,-1}, // Auto (ID: 311) // SF
	{579,-2087.3350,242.6618,35.5288,185.0567,-1,-1}, // Auto (ID: 312) // SF
	{579,-2050.6357,283.2310,34.7624,264.5675,-1,-1}, // Auto (ID: 313) // SF
	{567,-2126.7295,397.2755,35.0406,54.3366,-1,-1}, // Auto (ID: 314) // SF
	{490,-1954.9366,584.8658,35.2550,180.8713,-1,-1}, // Auto (ID: 316) // SF
	{490,-1935.9454,584.9206,35.2570,180.0867,-1,-1}, // Auto (ID: 317) // SF
	{601,-1587.4941,651.8170,6.9462,178.5285,-1,-1}, // Police (ID: 318) // SF
	{599,-1610.8427,652.3440,7.3795,2.0510,-1,-1}, // Police (ID: 319) // SF
	{598,-1628.4972,652.8290,6.9368,2.5589,-1,-1}, // Police (ID: 320) // SF
	{597,-1593.4799,673.0730,6.9556,177.4666,-1,-1}, // Police (ID: 321) // SF
	{490,-1623.1764,654.2357,-5.1154,88.5734,-1,-1}, // FBI (ID: 322) // SF
	{490,-1573.9741,711.8777,-5.1142,86.5410,-1,-1}, // FBI (ID: 323) // SF
	{490,-1600.3843,677.0266,-5.1156,352.5304,-1,-1}, // FBI (ID: 324) // SF
	{451,-1507.5999,696.1698,6.8925,89.6755,-1,-1}, // Turismo (ID: 325) // SF
	{451,-1507.7426,713.2293,6.8937,90.6318,-1,-1}, // Turismo (ID: 326) // SF
	{451,-1507.7679,729.2344,6.8953,92.3519,-1,-1}, // Turismo (ID: 327) // SF
	{451,-1507.7490,748.5741,6.8924,90.6270,-1,-1}, // Turismo (ID: 328) // SF
	{451,-1507.7958,770.8658,6.8919,90.4308,-1,-1}, // Turismo (ID: 329) // SF
	{451,-1507.7052,796.4244,6.8945,89.9744,-1,-1}, // Turismo (ID: 330) // SF
	{411,-1504.6947,896.0245,6.9146,84.2447,-1,-1}, // Infernus (ID: 331) // SF
	{411,-1507.5419,958.5471,6.9146,122.7027,-1,-1}, // Infernus (ID: 332) // SF
	{409,-1557.8887,1099.0873,6.9875,0.2394,-1,-1}, // Auto (ID: 333) // SF
	{402,-1652.1563,1310.9948,6.8659,133.8745,-1,-1}, // Auto (ID: 334) // SF
	{400,-1638.4492,1296.6136,7.1287,134.7598,-1,-1}, // Auto (ID: 335) // SF
	{603,-1768.3728,1388.2278,7.0261,111.1061,-1,-1}, // Auto (ID: 336) // SF
	{602,-1998.4730,1331.4952,6.9949,140.1625,-1,-1}, // Auto (ID: 337) // SF
	{602,-1942.8453,1328.0875,6.9972,137.0249,-1,-1}, // Auto (ID: 338) // SF
	{579,-2644.1990,1342.2625,7.0970,274.2010,-1,-1}, // Auto (ID: 339) // SF
	{567,-2643.2715,1363.1488,7.0274,271.0185,-1,-1}, // Auto (ID: 340) // SF
	{561,-2625.7007,1377.8389,6.9515,179.5933,-1,-1}, // Auto (ID: 341) // SF
	{451,-2488.0798,-130.1407,25.3313,90.1580,-1,-1}, // Auto (ID: 342) // SF
	{451,-2513.6462,-23.8104,25.3237,311.3078,-1,-1}, // Auto (ID: 343) // SF
	{411,-2437.9417,98.6580,34.8989,272.3707,-1,-1}, // Auto (ID: 344) // SF
	{409,-2431.5303,260.2194,34.9708,314.1759,-1,-1}, // Auto (ID: 345) // SF
	{602,-2415.7192,329.1691,34.7764,326.6674,-1,-1}, // Auto (ID: 346) // SF
	{603,-2515.5090,355.4220,34.9493,249.7173,-1,-1}, // Auto (ID: 347) // SF
	{587,-2523.8950,333.8923,34.8436,251.9313,-1,-1}, // Auto (ID: 348) // SF
	{579,-2421.6296,521.2862,29.8585,210.2830,-1,-1}, // Auto (ID: 349) // SF
	{587,-2543.4827,592.1250,14.1794,92.9391,-1,-1}, // Auto (ID: 350) // SF
	{579,-2695.8940,620.5078,14.3841,217.2180,-1,-1}, // Auto (ID: 351) // SF
	{416,-2635.7048,607.8090,14.6024,177.5644,-1,-1}, // Auto (ID: 352) // SF
	{416,-2662.1301,608.0881,14.6032,177.9949,-1,-1}, // Auto (ID: 353) // SF
	{411,-2877.2422,487.2064,4.6411,269.4157,-1,-1}, // Auto (ID: 354) // SF
	{446,-2981.0469,502.2260,-0.6398,355.3335,-1,-1}, // Auto (ID: 355) // SF
	{429,-2876.2529,739.6078,29.8550,278.6859,-1,-1}, // Auto (ID: 356) // SF
	{424,-2875.3853,792.4725,35.3783,273.4011,-1,-1}, // Auto (ID: 357) // SF
	{418,-2838.1660,914.6958,44.1476,280.3456,-1,-1}, // Auto (ID: 358) // SF
	{411,-2890.4204,1020.8049,36.2284,291.5313,-1,-1}, // Auto (ID: 359) // SF
	{409,-2855.3572,1036.0724,35.5385,77.5926,-1,-1}, // Auto (ID: 360) // SF
	{400,-2796.4077,769.5134,50.4558,48.4139,-1,-1}, // Auto (ID: 361) // SF
	{402,-2851.2402,968.6960,43.5444,302.4397,-1,-1}, // Auto (ID: 362) // SF
	{403,-2895.8320,1100.4913,28.1590,299.8861,-1,-1}, // Auto (ID: 363) // SF
	{417,-2878.5413,1237.6075,7.1902,197.6368,-1,-1}, // Auto (ID: 364) // SF
	{451,-2521.1653,1228.6642,37.1337,213.9064,-1,-1}, // Auto (ID: 365) // SF
	{463,-2512.0850,1209.8154,36.9624,270.6713,-1,-1}, // Auto (ID: 366) // SF
	{411,-2569.3943,1144.0651,55.4536,157.7966,-1,-1}, // Auto (ID: 367) // SF
	{400,-2532.2505,1135.7681,55.8189,175.4355,-1,-1}, // Auto (ID: 368) // SF
	{401,-2493.3125,1134.3114,55.5064,183.5164,-1,-1}, // Auto (ID: 369) // SF
	{402,-2454.7822,1134.7725,55.5600,178.4926,-1,-1}, // Auto (ID: 370) // SF
	{405,-2404.0977,1129.9119,55.6073,165.7598,-1,-1}, // Auto (ID: 371) // SF
	{420,-2464.4084,1072.2537,55.5969,358.8495,-1,-1}, // Auto (ID: 372) // SF
	{424,-2663.6035,992.5733,64.5628,3.0704,-1,-1}, // Auto (ID: 373) // SF
	{463,-2725.6790,914.6897,67.1378,120.1477,-1,-1}, // Auto (ID: 374) // SF
	{463,-2714.0022,869.6104,70.2435,85.4766,-1,-1}, // Auto (ID: 375) // SF
	{455,-2637.3391,801.0048,50.3795,0.7318,-1,-1}, // Auto (ID: 376) // SF
	{451,-2635.5100,930.7631,71.3910,197.7253,-1,-1}, // Auto (ID: 377) // SF
	{451,-2569.0078,991.2773,77.9803,0.6907,-1,-1}, // Auto (ID: 378) // SF
	{411,-2555.3247,860.2343,57.6848,104.8380,-1,-1}, // Auto (ID: 379) // SF
	{411,-2516.3059,825.3008,49.7504,88.3804,-1,-1}, // Auto (ID: 380) // SF
	{420,-2351.9412,982.9510,50.4755,10.6711,-1,-1}, // Auto (ID: 381) // SF
	{424,-2366.6484,1003.1662,50.4823,176.2973,-1,-1}, // Auto (ID: 382) // SF
	{426,-2189.0088,1032.4108,79.7504,180.4987,-1,-1}, // Auto (ID: 383) // SF
	{429,-2194.1152,977.3408,79.6797,271.8320,-1,-1}, // Auto (ID: 384) // SF
	{458,-2182.0625,1002.1577,79.8786,0.9060,-1,-1}, //  Auto (ID: 385) // SF
	{470,-2118.2817,742.1787,69.5524,89.9266,-1,-1}, // Auto (ID: 386) // SF
	{474,-1884.9944,948.3503,34.9370,164.5348,-1,-1}, // Auto (ID: 387) // SF
	{471,-1797.6034,822.3680,24.3719,0.0816,-1,-1}, // Auto (ID: 388) // SF
	{477,-1750.6913,954.2141,24.4960,91.5292,-1,-1}, // Auto (ID: 389) // SF
	{479,-1739.1060,819.4288,24.6904,328.5216,-1,-1}, // Auto (ID: 390) // SF
	{480,-1762.6598,1089.0397,45.2185,90.6965,-1,-1}, // Auto (ID: 391) // SF
	{480,-2044.2681,1110.2190,53.0616,123.0241,-1,-1}, // Auto (ID: 392) // SF
	{489,-1688.0280,1003.9207,17.7300,88.2604,-1,-1}, // Auto (ID: 393) // SF
	{495,-1735.4352,1033.0283,17.9320,268.9471,-1,-1}, // Auto (ID: 394) // SF
	{500,-1720.4497,1008.3136,17.6866,89.8001,-1,-1}, // Auto (ID: 395) // SF
	{518,-1913.5210,881.3893,34.9892,211.4028,-1,-1} // Auto (ID: 396) // SF
};

#define MAX_VEHICLE_SM 69
#define MAX_RAMDON_VEHICLE_SM 11

new VehicleRamdomArraySM[MAX_RAMDON_VEHICLE_SM]={478,404,531,509,403,468,505,542,
424,498,543};//11

new Float:VehicleRamdomPosArraySM[MAX_VEHICLE_SM][4]={
{328.7019,-53.0876,1.2140,271.0760},//0
{154.4323,-77.1626,1.2068,269.9025},
{-201.9606,-246.6348,1.1271,357.6774},
{250.0962,-158.4173,1.2793,88.4331},
{667.7983,-464.4435,16.0413,91.0762},
{771.1861,-548.4809,16.6968,182.0957},
{676.4682,-642.8137,15.9642,182.1092},
{658.0015,-570.7182,16.0408,357.5504},
{1280.0284,195.2066,19.4349,152.9031},
{1355.0891,244.9154,19.2722,248.1736},
{1410.9962,457.4325,19.9217,342.3036},//10
{1299.0088,284.3653,19.1811,152.5258},
{2231.3264,171.7914,27.1851,4.2994},
{2196.2104,-45.6248,27.0742,89.8548},
{2553.0461,1.8066,26.1817,271.9390},
{2338.7930,54.8933,26.1127,181.8722},
{-272.6209,-2181.5281,28.6987,112.4012},
{-13.3816,-2509.7925,36.5258,307.9699},
{-783.6390,-2769.2915,74.1089,113.9067},
{-1572.2274,-2732.7686,48.4096,143.1603},
{-2146.3145,-2446.8003,30.4952,46.7589},//20
{18.6269,-2660.4504,40.4058,3.5751},
{-2235.1724,-2571.4729,31.7882,63.0959},
{-2107.3735,-2240.8069,30.4930,150.3123},
{-2217.9146,-2406.5029,31.1500,58.4316},//24
{-1938.2120,2386.7361,49.2730,112.6150},
{-1557.5442,2696.1633,55.5667,263.1153},
{-1463.2239,2596.3276,55.5381,269.4921},
{-1400.8033,2634.3274,55.4992,268.0698},
{-1299.9828,2706.1172,49.8429,3.5839},
{-856.8224,2748.8413,45.6306,218.7507},//30
{-765.1003,2759.5217,45.5542,356.9624},
{-628.5353,2728.4875,71.8233,184.0104},
{-315.5432,2730.0576,62.4653,299.7276},
{-210.1090,2766.3562,62.3395,179.1887},
{-208.4061,2595.1277,62.4815,181.1197},
{-235.9215,2608.3582,62.4835,0.5678},
{394.7266,2680.0237,58.7849,269.0116},
{505.3836,2386.1179,29.6988,141.4350},
{526.2687,2369.9592,30.1079,151.8170},
{384.6627,2536.2534,16.3185,182.4209},//40
{685.8184,1945.3977,5.3178,358.9786},
{655.8569,1719.2957,6.7747,222.0539},
{187.0011,1406.1100,10.3665,83.5665},
{590.4337,1245.9359,11.4938,30.8492},
{170.5016,1184.1246,14.5332,344.8493},
{19.9102,1166.8236,19.3234,181.5738},
{9.1188,1166.1266,19.3601,175.4792},
{-88.6482,972.8857,19.6928,181.6949},
{-304.0310,1019.9312,19.3749,86.8242},
{-314.0564,1164.7030,19.5214,2.8051},//50
{-88.3406,1339.7938,10.4342,180.8341},
{-292.2176,1308.3595,53.8360,259.1398},
{-330.6194,1515.5671,75.1373,177.3547},
{-301.4783,1763.4614,42.4669,84.4600},
{-669.1708,2079.0803,60.1601,142.7533},
{-912.9413,1993.4308,60.6930,128.8189},
{-1199.4398,1818.7620,41.4982,221.8029},
{-799.3743,1557.8745,26.9001,261.5706},
{-788.2034,1496.0675,22.5791,89.2596},
{-891.1844,1517.7161,25.7023,289.9811},//60
{-819.9376,1442.1714,13.5679,129.9008},
{-305.8023,828.6334,13.0639,189.2629},
{-174.4183,1046.0419,19.4990,271.7773},
{-27.0100,1112.9166,19.5275,355.4910},
{17.3525,975.7373,19.4850,274.7765},
{75.6454,1167.0582,18.4429,358.7136},
{693.2573,713.4386,21.2988,276.2463},
{833.3164,841.6208,11.5372,27.7178}//68
};

//#define Pickups 11
enum PickupInfos {
	PickupModelID,
	PickupType,
	Float:PickupSpawnX,
	Float:PickupSpawnY,
	Float:PickupSpawnZ
}
/*new PickupInfo[Pickups][PickupInfos] = {
	{353,2,2026.7345,1252.1343,10.8203},
	{356,2,2026.7561,1262.6584,10.8203},
	{353,2,2017.2723,1262.2365,10.8130},
	{355,2,2012.0667,1253.0894,10.8203},
	{353,2,2022.4763,1283.6265,10.8130},
	{353,2,2031.7660,1293.1682,10.8203},
	{356,2,2031.3895,1285.2173,10.8203},
	{355,2,2031.7961,1303.3497,10.8203},
	{370,2,2025.3735,1343.1584,10.8203},
	{358,2,2028.8003,1352.2825,10.8203},
	{358,2,2029.0558,1334.6833,10.8203}
};*/

new WeaponNames[55][20] = {
	"Hands","Brassknuckle","Golf Club","Nitestick","Knife","Baseball Bat","Shovel","Pool Cue",
	"Katana","Chainsaw","Purple Dildo","White Dildo","Long Vibrator","Vibrator","Flowers","Cane","Grenade",
	"Teargas","Molotov","","","","Pistol","Silenced Pistol","Desert Eagle","Shotgun",
	"Sawnoff Shotgun","Spas 12","Micro Uzi","MP5","AK-47","M4","Tec-9","Rifle","Sniper Rifle",
	"RPG-7","Heatseeker","Flamethrower","Minigun","Satchel","Detonator","Spray Can",
	"Fire Extinguisher","Camera","","","Parachute","","","Vehicle","","","","Drown","Collision"
};

new SpawnWeapons[6] = {24,70,25,50,30,300};
#define Weapons 13
enum WeaponInfos {
	WeaponID,
	WeaponGroup,
	WeaponCost,
	bool:IsWeaponMelee
}
new WeaponInfo[Weapons][WeaponInfos] = {
	{3,0,1500,true},
	{4,0,2000,true},
	{5,0,1000,true},
	{23,1,20,false},
	{24,1,80,false},
	{25,2,40,false},
	{33,2,10000,false},
	{29,3,30,false},
	{34,3,500,false},
	{30,4,40,false},
	{31,4,50,false},
	{16,4,1000,false},
	{46,5,2000,true}
};

/*#define Options 5

enum SystemCfgOptions {
	ServerPlayersCount,
	EchoBagPlusCMsg,
	BanAccount,
	AntiChit,
	AntiFlood
}

new SystemCfgInfo[SystemCfgOptions];

ClearConfig(){
   SystemCfgInfo[ServerPlayersCount]=0;
   //SystemCfgInfo[EchoBagPlusCMsg]=false;
   SystemCfgInfo[BanAccount]=false;
}

LoadConfig(){
   SystemCfgInfo[EchoBagPlusCMsg]=dini_Int(SystemConfig,"EchoBagC");
   SystemCfgInfo[BanAccount]=dini_Int(SystemConfig,"BanAccount");
   SystemCfgInfo[AntiChit]=dini_Int(SystemConfig,"AntiChit");
   SystemCfgInfo[AntiFlood]=dini_Int(SystemConfig,"AntiFlood");
}*/

#define WeaponGroups 6

enum PlayerInfos {
	Name[MAX_PLAYER_NAME],
	#if defined Teams
		Team,
	#endif
	Admin,
	bool:AdminColored,
	bool:HearAll,
	Bans,
	Query,
	bool:Ignores[MAX_PLAYERS],
	PlayerIP[16],
	Moneys,
	WeaponIDs[WeaponGroups],
	WeaponAmmos[WeaponGroups],
	CheatKills,
	CheatDeaths,
	IdleTime,
	Float:LastPosX,
	Float:LastPosY,
	Float:LastPosZ,
    Float:PosX,
    Float:PosY,
    Float:PosZ,
	Messages,
	Mute,
	MuteTimer,
	Jailed,
	JailedTime,
	#if defined AntiSpawnKillTime
		bool:CanBeKilled,
		AntiSpawnKillTimer,
	#endif
	bool:SafeDeath,
	bool:Logged,
	Password,
	WrongPasswords,
	Model,
	bool:ModelSet,
	Kills,
	MaxKillsForLife,
	CurrentKillsForLife,
	Deaths,
	Suicides,
	Level,
	Bank,
	House,
	Vehicle,
	TargetID,
	PMType,
	PMSelectType,
    AFK,
    Text3D:AFKMsg,
    NikColor,
    Freeze,
    Spawn,
    Hitman,
    HitmanAct,
    LogginType,//user option
    MinusHealth, //здоровье над головой в цифрах
    DuelCreate,
    DuelChange
}
new PlayerInfo[MAX_PLAYERS][PlayerInfos];

EncodeName(playername[]) {
	new str[MAX_STRING];
	set(str,strlower(playername));
	#if defined AllowBadSymbolsInNicks
		str = strreplace("(","%L%",str);
		str = strreplace(")","%R%",str);
		str = strreplace("%L%","(40)",str);
		str = strreplace("%R%","(41)",str);
		str = strreplace("[","(91)",str);
		str = strreplace("]","(93)",str);
		str = strreplace("{","(123)",str);
		str = strreplace("}","(124)",str);
		str = strreplace("/","(47)",str);
		str = strreplace("\\","(92)",str);
		str = strreplace("-","(45)",str);
		str = strreplace("_","(95)",str);
		str = strreplace("!","(33)",str);
		str = strreplace("?","(63)",str);
		str = strreplace(",","(44)",str);
		str = strreplace(".","(46)",str);
		str = strreplace(";","(59)",str);
		str = strreplace(":","(58)",str);
		str = strreplace("'","(39)",str);
		str = strreplace("\"","(34)",str);
		str = strreplace("`","(96)",str);
		str = strreplace("~","(126)",str);
		str = strreplace("<","(60)",str);
		str = strreplace(">","(62)",str);
		str = strreplace("@","(64)",str);
		str = strreplace("#","(35)",str);
		str = strreplace("$","(36)",str);
		str = strreplace("%","(37)",str);
		str = strreplace("^","(94)",str);
		str = strreplace("&","(38)",str);
		str = strreplace("*","(42)",str);
		str = strreplace("=","(61)",str);
		str = strreplace("+","(43)",str);
	#endif
	return str;
}

PlayerFile(playername[]) {
	new str[MAX_STRING];
	format(str,sizeof(str),"%s%s%s",PlayersDir,EncodeName(playername),PlayersExt);
	return str;
}

ClearPlayer(playerid) {
	PlayerInfo[playerid][Name][0] = 0;
	#if defined Teams
		PlayerInfo[playerid][Team] = -1;
	#endif
	PlayerInfo[playerid][Admin] = 0;
	PlayerInfo[playerid][AdminColored] = false;
	PlayerInfo[playerid][HearAll] = false;
	PlayerInfo[playerid][Query] = INVALID_PLAYER_ID;
	for (new i=0;i<MAX_PLAYERS;i++) PlayerInfo[playerid][Ignores][i] = false;
	PlayerInfo[playerid][Moneys] = 0;
	for (new i=0;i<WeaponGroups;i++) {
		PlayerInfo[playerid][WeaponIDs][i] = 0;
		PlayerInfo[playerid][WeaponAmmos][i] = 0;
	}
	PlayerInfo[playerid][IdleTime] = 0;
	PlayerInfo[playerid][CheatKills] = 0;
	PlayerInfo[playerid][CheatDeaths] = 0;
	PlayerInfo[playerid][IdleTime] = 0;
	PlayerInfo[playerid][LastPosX] = 0;
	PlayerInfo[playerid][LastPosY] = 0;
	PlayerInfo[playerid][LastPosZ] = 0;
	PlayerInfo[playerid][PosX] = 0;
    PlayerInfo[playerid][PosY] = 0;
    PlayerInfo[playerid][PosZ] = 0;
	PlayerInfo[playerid][Messages] = 0;
	PlayerInfo[playerid][Mute] = 0;
	PlayerInfo[playerid][Jailed] = 0;
	PlayerInfo[playerid][PlayerIP] = 0;
	KillTimer(PlayerInfo[playerid][MuteTimer]);
	KillTimer(PlayerInfo[playerid][JailedTime]);
	#if defined AntiSpawnKillTime
		PlayerInfo[playerid][CanBeKilled] = false;
		KillTimer(PlayerInfo[playerid][AntiSpawnKillTimer]);
	#endif
	PlayerInfo[playerid][SafeDeath] = false;
	PlayerInfo[playerid][Logged] = false;
	PlayerInfo[playerid][Bans] = 0;
	PlayerInfo[playerid][Password] = 0;
	PlayerInfo[playerid][WrongPasswords] = 0;
	PlayerInfo[playerid][Model] = 0;
	PlayerInfo[playerid][ModelSet] = false;
	PlayerInfo[playerid][Kills] = 0;
	PlayerInfo[playerid][MaxKillsForLife] = 0;
	PlayerInfo[playerid][CurrentKillsForLife] = 0;
	PlayerInfo[playerid][Deaths] = 0;
	PlayerInfo[playerid][Suicides] = 0;
	PlayerInfo[playerid][PMType] = 0;
	PlayerInfo[playerid][PMSelectType] = 0;
	PlayerInfo[playerid][AFK] = 0;
    PlayerInfo[playerid][NikColor] = 0;
    Delete3DTextLabel(PlayerInfo[playerid][AFKMsg]);
    PlayerInfo[playerid][Freeze] = 0;
    PlayerInfo[playerid][Spawn] = 0;
    PlayerInfo[playerid][Hitman] = 0;
    PlayerInfo[playerid][HitmanAct] = 0;
    PlayerInfo[playerid][LogginType] = 0;
    PlayerInfo[playerid][DuelCreate] = 0;
    PlayerInfo[playerid][DuelChange] = 0;
}

LoadPlayer(playerid) {
	if (!IsPlayerConnected(playerid)) return;
	ClearPlayer(playerid);
	GetPlayerName(playerid,PlayerInfo[playerid][Name],MAX_PLAYER_NAME);
	new filename[MAX_STRING];
	filename = PlayerFile(PlayerInfo[playerid][Name]);
	if (!dini_Exists(filename)) return;
	PlayerInfo[playerid][Mute] = dini_Int(filename,"Mute");
	if (PlayerInfo[playerid][Mute]) PlayerInfo[playerid][MuteTimer] = SetTimerEx("UnMutePlayerT",PlayerInfo[playerid][Mute]*60000,0,"i",playerid);
	PlayerInfo[playerid][Jailed] = dini_Int(filename,"Jailed");
	PlayerInfo[playerid][Logged] = false;
	PlayerInfo[playerid][Bans] = dini_Int(filename,"Bans");
	PlayerInfo[playerid][PlayerIP] = dini_Int(filename,"IP");
	PlayerInfo[playerid][Admin] = dini_Int(filename,"Admin");
	PlayerInfo[playerid][Password] = dini_Int(filename,"Password");
	PlayerInfo[playerid][Model] = dini_Int(filename,"Model");
	GiveMoney(playerid,dini_Int(filename,"Moneys"));
	PlayerInfo[playerid][Kills] = dini_Int(filename,"Kills");
	PlayerInfo[playerid][MaxKillsForLife] = dini_Int(filename,"MaxKillsForLife");
	PlayerInfo[playerid][Deaths] = dini_Int(filename,"Deaths");
	PlayerInfo[playerid][Suicides] = dini_Int(filename,"Suicides");
	SetPlayerScore(playerid,PlayerInfo[playerid][Kills]-PlayerInfo[playerid][Suicides]);
	PlayerInfo[playerid][LogginType] = dini_Int(filename,"LogginType");
}

SavePlayer(playerid) {
	if (!IsPlayerConnected(playerid) || !PlayerInfo[playerid][Logged]) return;
	new filename[MAX_STRING],plrIP[16];
	filename = PlayerFile(PlayerInfo[playerid][Name]);
	if (!dini_Exists(filename)) return;
	dini_IntSet(filename,"Mute",PlayerInfo[playerid][Mute]);
	dini_IntSet(filename,"Bans",PlayerInfo[playerid][Bans]);
	dini_IntSet(filename,"Password",PlayerInfo[playerid][Password]);
	dini_IntSet(filename,"Model",PlayerInfo[playerid][Model]);
 	dini_IntSet(filename,"Moneys",PlayerInfo[playerid][Moneys]);
	dini_IntSet(filename,"Kills",PlayerInfo[playerid][Kills]);
	dini_IntSet(filename,"MaxKillsForLife",PlayerInfo[playerid][MaxKillsForLife]);
	dini_IntSet(filename,"Deaths",PlayerInfo[playerid][Deaths]);
	dini_IntSet(filename,"Suicides",PlayerInfo[playerid][Suicides]);
	dini_IntSet(filename,"Jailed",PlayerInfo[playerid][Jailed]);
	dini_IntSet(filename,"LogginType",PlayerInfo[playerid][LogginType]);
	GetPlayerIp(playerid, plrIP, sizeof(plrIP));
	dini_Set(filename,"IP",plrIP);
}

GetPlayerID(playername[]) {
	for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && equal(playername,PlayerInfo[i][Name],true)) return i;
	return INVALID_PLAYER_ID;
}

IsPlayerInArea(playerid,Float:x_min,Float:x_max,Float:y_min,Float:y_max,Float:z_min=-10000.0,Float:z_max=10000.0) {
	if (!IsPlayerConnected(playerid)) return false;
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	if (x_min <= x <= x_max && y_min <= y <= y_max && z_min <= z <= z_max) return true;
	return false;
}

#if defined LoggingTimeout
	public LoggingTimeoutT(playerid) if (IsPlayerConnected(playerid) && !PlayerInfo[playerid][Logged]) KickPlayer(playerid,"Не залогинелся.");
#endif

#if defined AntiSpawnKillTime
	public AntiSpawnKill(playerid) PlayerInfo[playerid][CanBeKilled] = true;
#endif

UnMutePlayer(playerid,unmuter[]="сервером") {
	if (!IsPlayerConnected(playerid) || !PlayerInfo[playerid][Mute]) return;
	new str[MAX_STRING];
	format(str,sizeof(str),"Игрок %s (id: %d) пращен %s",PlayerInfo[playerid][Name],playerid,unmuter);
	WriteToLog(str);
	#if defined MutesLog
		WriteToLog(str,MutesLog);
	#endif
	WriteEcho(str,INVALID_PLAYER_ID,MuteMsgColor);
	#if defined IrcOnOff
	format(str,sizeof(str),"04Игрок %s (id: %d) пращен %s",PlayerInfo[playerid][Name],playerid,unmuter);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	PlayerInfo[playerid][Mute] = 0;
	KillTimer(PlayerInfo[playerid][MuteTimer]);
}

UnJailedPlayer(playerid) {
	if (!IsPlayerConnected(playerid) || !PlayerInfo[playerid][Jailed]) return;
	new str[256];
	format(str,sizeof(str),"Игрок \"%s\" освабодился из тюрьмы",PlayerInfo[playerid][Name]);
	WriteEcho(str,INVALID_PLAYER_ID,MuteMsgColor);
	#if defined IrcOnOff
	format(str,sizeof(str),"04Игрок \"%s\" освабодился из тюрьмы",PlayerInfo[playerid][Name]);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	PlayerInfo[playerid][Jailed] = 0;
	KillTimer(PlayerInfo[playerid][JailedTime]);
	SetPlayerInterior(playerid,0);
	SetPlayerPos(playerid,2343.1265,2457.8074,14.9688);
	SetPlayerFacingAngle(playerid,0);
	TogglePlayerControllable(playerid, 1);
}

UnTogglePlayerControlT(playerid){
	TogglePlayerControllable(playerid, 1);
}

DeletiAFKLebel(playerid){//DeletiAFKLebelT()
   //доп. удаление AFK
   if(!PlayerInfo[playerid][AFK] && PlayerInfo[playerid][AFKMsg]){
          //Delete3DTextLabel(PlayerInfo[playerid][AFKMsg]);
          //SetPlayerColor(playerid,PlayerInfo[playerid][NikColor]);
          //PlayerInfo[playerid][AFK]=0;
          //(PlayerInfo[playerid][AFKMsg]);
   }
   return 1;
}

public UnMutePlayerT(playerid) UnMutePlayer(playerid);
public UnJailedPlayerT(playerid) UnJailedPlayer(playerid);
public TogglePlayerControlT(playerid) UnTogglePlayerControlT(playerid);
public DeletiAFKLebelT(){
   for(new i=0;i<MAX_PLAYERS;i++){
      DeletiAFKLebel(i);
   }
}

KickPlayer(playerid,reason[],kicker[]="сервером") {
	if (!IsPlayerConnected(playerid) || IsPlayerAdmin(playerid) || PlayerInfo[playerid][Admin] >= AdminLevelToIgnorePunishment) return;
	new str[MAX_STRING];
	format(str,sizeof(str),"Игрок %s (id: %d) кикнут %s. Причина: %s",PlayerInfo[playerid][Name],playerid,kicker,reason);
	WriteToLog(str);
	#if defined KicksLog
		WriteToLog(str,KicksLog);
	#endif
	WriteEcho(str,INVALID_PLAYER_ID,KickMsgColor);
	#if defined IrcOnOff
	format(str,sizeof(str),"04Игрок %s (id: %d) кикнут %s. Причина: %s",PlayerInfo[playerid][Name],playerid,kicker,reason);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	Kick(playerid);
}

BanPlayer(playerid,reason[],banner[]="сервером") {
	if (!IsPlayerConnected(playerid) || IsPlayerAdmin(playerid) || PlayerInfo[playerid][Admin] >= AdminLevelToIgnorePunishment) return;
	new str[MAX_STRING];
	format(str,sizeof(str),"Игрок %s (id: %d) забанен %s. Причина: %s",PlayerInfo[playerid][Name],playerid,banner,reason);
	WriteToLog(str);
	#if defined BansLog
		WriteToLog(str,BansLog);
	#endif
	WriteEcho(str,INVALID_PLAYER_ID,BanMsgColor);
	#if defined IrcOnOff
	format(str,sizeof(str),"04Игрок %s (id: %d) забанен %s. Причина: %s",PlayerInfo[playerid][Name],playerid,banner,reason);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	PlayerInfo[playerid][Bans]=1;
	Ban(playerid);
}

GiveMoney(playerid,amount) {
	PlayerInfo[playerid][Moneys] += amount;
	GivePlayerMoney(playerid,amount);
}

#if defined TimeCycle
	new WorldTime = 12;
	public WorldTimeUpdate() {
		WorldTime++;
		WorldTime %= 24;
		SetWorldTime(WorldTime);
	}
#endif

public SaveAllPlayers() {
	for (new i=0;i<MAX_PLAYERS;i++) SavePlayer(i);
	WriteToLog("Global save done");
    WriteEcho("Игровой процесс сохранен...");
}

#define RestrictedAreas 4
#if defined RestrictedAreas
	new Float:RestrictedAreaInfo[RestrictedAreas][6] = {
		{284.0852,298.1549,-112.7213,-102.9336,1000.0,1010.0},
		{284.2424,299.8185,-41.4566,-31.2172,1000.0,1010.0},
		{284.6116,303.0293,-86.4009,-56.8201,1000.0,1010.0},
		{306.3991,319.0888,-169.8648,-158.7572,999.0,1009.0}
	};
	public AreasCheck() {
		for (new i=0;i<MAX_PLAYERS;i++) {
			if (IsPlayerConnected(i) && GetPlayerState(i) == PLAYER_STATE_ONFOOT && !IsPlayerAdmin(i) && PlayerInfo[i][Admin] < AdminLevelToIgnorePunishment) {
				for (new j=0;j<RestrictedAreas;j++) {
					if (IsPlayerInArea(i,RestrictedAreaInfo[j][0],RestrictedAreaInfo[j][1],RestrictedAreaInfo[j][2],RestrictedAreaInfo[j][3],RestrictedAreaInfo[j][4],RestrictedAreaInfo[j][5])) {
						PlayerInfo[i][SafeDeath] = true;
						SetPlayerHealth(i,0);
						WriteEcho("Не заходи сюда больше.",i,ErrorMsgColor);
					}
				}
			}
		}
	}
#endif

new a51[MAX_PLAYERS];
#define ZoneAreas 3
new Float:ZoneAreasInfo[ZoneAreas][3]={
   {-2386.5173,2368.0161,356.0}, //villa
   {212.6797,1906.0068,420.19}, //zone51
   {-2727.2717,2356.6458,10.0685} //villa vorota
};
IsPlayerInOkr(playerid,Float:x0,Float:y0,Float:rad,Float:z_min=-10000.0,Float:z_max=10000.0) {
   if(!IsPlayerConnected(playerid)) return false;
   new Float:x,Float:y,Float:z;
   GetPlayerPos(playerid,x,y,z);
   if(((x-x0)*(x-x0) + (y-y0)*(y-y0))<=rad*rad && z>z_min && z<z_max) return true;
   return false;
}

new gVorotaT[MAX_PLAYERS],gVorotaOpen[MAX_PLAYERS];
public CloseVarota(playerid){
   if(IsPlayerInOkr(playerid,ZoneAreasInfo[2][0],ZoneAreasInfo[2][1],ZoneAreasInfo[2][2])) return 0;
   SetObjectRot(vorota1,0.0,269.19006347656,97.25);
   SetObjectRot(vorota2,0.0,269.06945800781,279.11315917969);
   KillTimer(gVorotaT[playerid]);
   gVorotaOpen[playerid]=0;
   return 1;
}

/*public AreasCheckNew() {
   new str[MAX_PLAYERS];
   for (new i;i<MAX_PLAYERS;i++) {
   if(IsPlayerConnected(i)) {
      if(IsPlayerInAnyVehicle(i)&&!IsPlayerInOkr(i,ZoneAreasInfo[1][0], ZoneAreasInfo[1][1], ZoneAreasInfo[1][2])){
         if((GetVehicleModel(GetPlayerVehicleID(i))==425||GetVehicleModel(GetPlayerVehicleID(i))==520)){
            SetVehicleToRespawn(GetPlayerVehicleID(i));
            SendClientMessage(i, BanMsgColor, "Вы вылетели за пределы базы");
         }
         if(GetVehicleModel(GetPlayerVehicleID(i))==432){
            SetVehicleToRespawn(GetPlayerVehicleID(i));
            SendClientMessage(i, BanMsgColor, "Вы выехали за пределы базы");
         }
      }
      if(IsPlayerInOkr(i,ZoneAreasInfo[2][0],ZoneAreasInfo[2][1],ZoneAreasInfo[2][2])){
         MoveObject(vorota1, -2727.0791015625, 2365.5478515625, 71.64030456543, 2.00);
         WriteEcho("Сим сим откройся!",i);
         //MoveObject(vorota2, 0, 0, 10, 2.00);
         //{-2727.0791015625,2365.5478515625,71.64030456543}
         //{-2724.8427734375,2348.0703125,71.679405212402,0.0,269.06945800781,279.11315917969}
		 //return 1;
	  }
      if (IsPlayerInOkr(i,ZoneAreasInfo[0][0],ZoneAreasInfo[0][1],ZoneAreasInfo[0][2])) {
         if(a51[i]!=1){
            if(!strcmp("[JRU]", PlayerInfo[i][Name], true, 5)){
			   format(str,sizeof(str),"Добро пожаловать домой, %s!",PlayerInfo[i][Name]);
	           WriteEcho(str,i,HelpMsgColor);
			   GameTextForPlayer(i,"~w~Welcome to house!", 2000, 6);
			}
			else {
            WriteEcho("Welcome to jru village",i,HelpMsgColor);
            GameTextForPlayer(i,"~w~Welcome to ~r~ JRU ~w~ village", 2000, 6);
            }
            a51[i]=1;
         }
      }
      else {
         a51[i]=0;
      }
   }
   }
}*/

public AreasCheckNew() {
   new str[MAX_PLAYERS];
   for (new i;i<MAX_PLAYERS;i++) {
   if(IsPlayerConnected(i)) {
      if(IsPlayerInAnyVehicle(i)&&!IsPlayerInOkr(i,ZoneAreasInfo[1][0], ZoneAreasInfo[1][1], ZoneAreasInfo[1][2])){
         if((GetVehicleModel(GetPlayerVehicleID(i))==425||GetVehicleModel(GetPlayerVehicleID(i))==520)){
            SetVehicleToRespawn(GetPlayerVehicleID(i));
            SendClientMessage(i, BanMsgColor, "Вы вылетели за пределы базы");
         }
         if(GetVehicleModel(GetPlayerVehicleID(i))==432){
            SetVehicleToRespawn(GetPlayerVehicleID(i));
            SendClientMessage(i, BanMsgColor, "Вы выехали за пределы базы");
         }
      }
      if(IsPlayerInOkr(i,ZoneAreasInfo[2][0],ZoneAreasInfo[2][1],ZoneAreasInfo[2][2]) && !gVorotaOpen[i]){
         if(!strcmp("[JRU]", PlayerInfo[i][Name], true, 5)){
            SetObjectRot(vorota1,0.0,357.43701171875,97.245483398438);
            SetObjectRot(vorota2,0.0,356.81994628906,279.11492919922);
            gVorotaOpen[i]=1;
         }
         else {
			WriteEcho("Посторонним въеэд запрещен!",i,ErrorMsgColor);
         }
      }
      if(!IsPlayerInOkr(i,ZoneAreasInfo[2][0],ZoneAreasInfo[2][1],ZoneAreasInfo[2][2]) && gVorotaOpen[i]==1){
         gVorotaT[i]=SetTimerEx("CloseVarota",7*1000,0,"i",i);
      }
      if (IsPlayerInOkr(i,ZoneAreasInfo[0][0],ZoneAreasInfo[0][1],ZoneAreasInfo[0][2])) {
         if(a51[i]!=1){
            if(!strcmp("[JRU]", PlayerInfo[i][Name], true, 5)){
			   format(str,sizeof(str),"Добро пожаловать домой, %s!",PlayerInfo[i][Name]);
	           WriteEcho(str,i,HelpMsgColor);
			   GameTextForPlayer(i,"~w~Welcome to house!", 2000, 6);
			}
			else {
            WriteEcho("Welcome to jru village",i,HelpMsgColor);
            GameTextForPlayer(i,"~w~Welcome to ~r~ JRU ~w~ village", 2000, 6);
            }
            a51[i]=1;
         }
      }
      else {
         a51[i]=0;
      }
   }
   }
}


#if defined IdleTimeToKick
	public IdleCheck() {
		new str[MAX_STRING],Float:x,Float:y,Float:z;
		for (new i=0;i<MAX_PLAYERS;i++) {
			if (IsPlayerConnected(i) && !PlayerInfo[i][Jailed] && !IsPlayerNPC(i)) {
				GetPlayerPos(i,x,y,z);
				if (x == PlayerInfo[i][LastPosX] && y == PlayerInfo[i][LastPosY] && z == PlayerInfo[i][LastPosZ] && GetPlayerState(i) != PLAYER_STATE_NONE && GetPlayerState(i) != PLAYER_STATE_WASTED) {
					PlayerInfo[i][IdleTime]++;
					if (IdleTimeToAfk == PlayerInfo[i][IdleTime]) {
					   PlayerInfo[i][AFK] = 1;
                       format(str, sizeof(str), " *** %s отошел(afk).",PlayerInfo[i][Name]);
	                   SendClientMessageToAll(COLOR_LIGHTBLUE, str);
	                   #if defined IrcOnOff
	                   format(str,sizeof(str),"11 *** %s отошел(afk).",PlayerInfo[i][Name]);
	                   IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	                   #endif
	                   SendClientMessage(i, SystemMsgColor, " * Что-бы вернутся, используйте команду /back или клавишу \"Enter\"");
	                   format(str,sizeof(str),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~%s ~w~is afk.",PlayerInfo[i][Name]);
	                   GameTextForAll(str,3000,3);
	                   PlayerInfo[i][NikColor] = GetPlayerColor(i);
	                   SetPlayerColor(i,COLOR_LIGHTBLUE);
	                   PlayerInfo[i][AFKMsg] = Create3DTextLabel("AFK",COLOR_LIGHTBLUE,30.0,40.0,50.0,40.0,0);
                       Attach3DTextLabelToPlayer(PlayerInfo[i][AFKMsg], i, 0.0, 0.0, 0.3);
	                   TogglePlayerControllable(i, 0);
					}
					if (IdleTimeToKick-1 == PlayerInfo[i][IdleTime]) {
						format(str,sizeof(str),"Ты бездействуешь уже %d минуты! Чтобы не быть кикнутым, нужно перемещатся.",PlayerInfo[i][IdleTime]);
						WriteEcho(str,i,ErrorMsgColor);
					}
					if (IdleTimeToKick <= PlayerInfo[i][IdleTime]) KickPlayer(i,"бездействие");
				}
				else {
					PlayerInfo[i][IdleTime] = 0;
					PlayerInfo[i][LastPosX] = x;
					PlayerInfo[i][LastPosY] = y;
					PlayerInfo[i][LastPosZ] = z;
				}
			}
		}
	}
#endif

#if defined FloodInterval && defined FloodLines
	public FloodCheck() for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i)) PlayerInfo[i][Messages] = 0;
#endif

public MoneyCheck() {
	for (new i=0;i<MAX_PLAYERS;i++) {
		if (IsPlayerConnected(i)) {
            #if defined MoneyCheck
			    if (GetPlayerMoney(i) > PlayerInfo[i][Moneys]) GivePlayerMoney(i,-GetPlayerMoney(i)+PlayerInfo[i][Moneys]);
			    else if (GetPlayerMoney(i) < PlayerInfo[i][Moneys] && !PlayerInfo[i][AFK]) PlayerInfo[i][Moneys] = GetPlayerMoney(i);
            #endif
			#if defined MaxMoneyIllegalIncrease
				if (GetPlayerMoney(i)-PlayerInfo[i][Moneys] > MaxMoneyIllegalIncrease) BanPlayer(i,"Использовал читы: читы на деньги");
			#endif
		}
	}
}

public MoneyForPlay() for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i)) GiveMoney(i,MoneysForPlaying);

public OnGameModeInit() {
    SetGameModeText(GameModeText);
	new str[MAX_STRING];
	print("\n\n--------------------------------------");
	printf("  %s by [JRU]Strelok (c) 2009",GameModeText);
	print("--------------------------------------\n\n");
	WriteToLog("Gamemode starting...");
	format(str,sizeof(str),"Gamemode: %s",GameModeText);
	WriteToLog(str);
	//LoadConfig();
	for (new i=0;i<Classes;i++) AddPlayerClass(ClassInfo[i],0,0,0,0,SpawnWeapons[0],SpawnWeapons[1],SpawnWeapons[2],SpawnWeapons[3],SpawnWeapons[4],SpawnWeapons[5]);
	#if defined Teams
		new TeamClasses;
		for (new i=0;i<Teams;i++) {
			for (new j=0;j<ModelsInTeam;j++) {
			    if (TeamInfo[i][TeamModels][j] == 0) break;
				AddPlayerClass(TeamInfo[i][TeamModels][j],TeamInfo[i][TeamSpawnX],TeamInfo[i][TeamSpawnY],TeamInfo[i][TeamSpawnZ],TeamInfo[i][TeamSpawnA],SpawnWeapons[0],SpawnWeapons[1],SpawnWeapons[2],SpawnWeapons[3],SpawnWeapons[4],SpawnWeapons[5]);
				if (j == 0) TeamInfo[i][TeamClassStart] = Classes+TeamClasses;
				TeamClasses++;
			}
			TeamInfo[i][TeamClassEnd] = Classes+TeamClasses-1;
		}
		format(str,sizeof(str),"Classes: %d",Classes+TeamClasses);
	#else
		format(str,sizeof(str),"Classes: %d",Classes);
	#endif
	WriteToLog(str);
	new models[212],modelids;
	for (new i=0;i<Vehicles;i++) {
		AddStaticVehicle(VehicleInfo[i][VehicleModelID],VehicleInfo[i][VehicleSpawnX],VehicleInfo[i][VehicleSpawnY],VehicleInfo[i][VehicleSpawnZ],VehicleInfo[i][VehicleSpawnA],VehicleInfo[i][VehicleColor1],VehicleInfo[i][VehicleColor2]);
        if (VehicleInfo[i][VehicleModelID] != 0) models[VehicleInfo[i][VehicleModelID]-400]++;
	}
	for(new i=0;i<VehiclesLS;i++){//транспорт LS
	   AddStaticVehicle(VehicleInfoLS[i][VehicleModelID],VehicleInfoLS[i][VehicleSpawnX],VehicleInfoLS[i][VehicleSpawnY],VehicleInfoLS[i][VehicleSpawnZ],VehicleInfoLS[i][VehicleSpawnA],VehicleInfoLS[i][VehicleColor1],VehicleInfoLS[i][VehicleColor2]);
	}
	for(new i=0;i<VehiclesSF;i++){//транспорт SF
	   AddStaticVehicle(VehicleInfoSF[i][VehicleModelID],VehicleInfoSF[i][VehicleSpawnX],VehicleInfoSF[i][VehicleSpawnY],VehicleInfoSF[i][VehicleSpawnZ],VehicleInfoSF[i][VehicleSpawnA],VehicleInfoSF[i][VehicleColor1],VehicleInfoSF[i][VehicleColor2]);
	}
    for (new i=0;i<212;i++) if (models[i] > 0) modelids++;

	format(str,sizeof(str),"Vehicles: %d (Types: %d)",Vehicles,modelids);
	WriteToLog(str);
	//<==================Сельская местность: транспорт===================>
    for(new i=0; i<MAX_VEHICLE_SM; i++){
       new ramd=random(sizeof(VehicleRamdomArraySM));
       AddStaticVehicle(VehicleRamdomArraySM[ramd],VehicleRamdomPosArraySM[i][0],VehicleRamdomPosArraySM[i][1],VehicleRamdomPosArraySM[i][2],VehicleRamdomPosArraySM[i][3],-1,-1);
    }
	//--
	//for (new i=0;i<Pickups;i++) AddStaticPickup(PickupInfo[i][PickupModelID],PickupInfo[i][PickupType],PickupInfo[i][PickupSpawnX],PickupInfo[i][PickupSpawnY],PickupInfo[i][PickupSpawnZ]);
	//format(str,sizeof(str),"Pickups: %d",Pickups);
	WriteToLog(str);
	#if defined HousesOnOff
    loadhouses();
    SetTimer("hous_time",1000,true);
    for (new a=0;a<picups;a++){
	   pick[a]=CreatePickup(picaps[a][model_p], picaps[a][type_p], picaps[a][X_p], picaps[a][Y_p], picaps[a][Z_p], -1);
	}
	#endif
    vorota1=CreateObject(968,-2727.0791015625,2365.5485839844,71.64030456543,0.0,269.19006347656,97.25);
    vorota2=CreateObject(968,-2724.8427734375,2348.0703125,71.679405212402,0.0,269.06945800781,279.11315917969);
    CreateObject(11453,-2536.0268554688,2266.3012695313,6.7801756858826,0.0,0.0,338.16500854492);
    CreateObject(966,-2727.0769042969,2365.6088867188,70.806831359863,0.0,0.0,97.265014648438);
    CreateObject(966,-2724.8251953125,2348.0454101563,70.8671875,0.0,0.0,279.02499389648);
    CreateObject(2985,-2725.9987792969,2356.7578125,70.873893737793,0.0,0.0,191.27502441406);
    CreateObject(967,-2727.2453613281,2367.1791992188,71.077613830566,0.0,0.0,8.0);
    CreateObject(967,-2724.4177246094,2346.5495605469,71.081024169922,0.0,0.0,189.12005615234);
    AddStaticVehicle(506,-2553.9855957031,2272.2229003906,4.853609085083,335.0,-1,-1);
    AddStaticVehicle(415,-2561.2866210938,2257.4956054688,4.9131774902344,334.75,-1,-1);
    AddStaticVehicle(522,-2559.6403808594,2255.5859375,4.7229309082031,335.75,-1,-1);
    AddStaticVehicle(522,-2558.4567871094,2254.931640625,4.7248530387878,337.0,-1,-1);
    AddStaticVehicle(481,-2554.4545898438,2256.3278808594,4.6712760925293,64.349975585938,-1,-1);
    AddStaticVehicle(510,-2551.537109375,2254.9755859375,4.7583417892456,62.260009765625,-1,-1);
    AddStaticVehicle(487,-2552.0104980469,2246.865234375,5.3275003433228,336.5,-1,-1);
    AddStaticVehicle(487,-2525.3713378906,2235.42578125,9.6860322952271,244.5,-1,-1);
    AddStaticVehicle(411,-2525.6484375,2256.4897460938,4.7670998573303,336.0,-1,-1);
    AddStaticVehicle(541,-2566.3112792969,2302.6162109375,4.6843748092651,196.56005859375,-1,-1);
    AddStaticVehicle(559,-2618.9641113281,2286.7824707031,7.8911166191101,179.50988769531,-1,-1);
    AddStaticVehicle(562,-2619.1550292969,2311.0241699219,7.8898730278015,179.3798828125,-1,-1);
    AddStaticVehicle(560,-2623.5759277344,2346.3481445313,8.2736759185791,88.055053710938,-1,-1);
    AddStaticVehicle(565,-2619.2106933594,2357.7861328125,8.2744970321655,178.78991699219,-1,-1);
    AddStaticVehicle(587,-2618.4423828125,2388.1232910156,10.188277244568,175.39489746094,-1,-1);
    AddStaticVehicle(602,-2615.708984375,2406.7878417969,12.281923294067,174.9150390625,-1,-1);
    AddStaticVehicle(603,-2611.1909179688,2360.2670898438,8.6328468322754,0.0,-1,-1);
    AddStaticVehicle(402,-2488.8215332031,2403.857421875,15.9493932724,31.760009765625,-1,-1);
    AddStaticVehicle(411,-2429.2255859375,2341.0537109375,4.7934441566467,103.22003173828,-1,-1);
    AddStaticVehicle(557,-2380.0600585938,2414.2854003906,9.0131092071533,326.25500488281,-1,-1);
    AddStaticVehicle(504,-2357.8459472656,2417.3859863281,7.0920720100403,55.844970703125,-1,-1);
    AddStaticVehicle(534,-2386.830078125,2433.4035644531,9.6356554031372,67.489990234375,-1,-1);
    AddStaticVehicle(535,-2423.4711914063,2439.4287109375,12.769613265991,85.35498046875,-1,-1);
    AddStaticVehicle(575,-2422.2219238281,2429.5690917969,12.598814964294,274.64501953125,-1,-1);
    AddStaticVehicle(409,-2474.1623535156,2437.4956054688,15.821475982666,98.030029296875,-1,-1);
    AddStaticVehicle(437,-2604.4028320313,2263.8190917969,8.4609375,51.609985351563,-1,-1);
    AddStaticVehicle(437,-2624.6762695313,2264.28125,8.3828525543213,316.32995605469,-1,-1);
    AddStaticVehicle(525,-2436.6760253906,2514.1220703125,14.050090789795,0.0,-1,-1);
    AddStaticVehicle(422,-2467.4072265625,2499.3308105469,16.920892715454,268.68994140625,-1,-1);
    AddStaticVehicle(568,-2368.1123046875,2521.0993652344,7.8236193656921,0.0,-1,-1);
    AddStaticVehicle(497,-2227.6970214844,2326.97265625,7.8118753433228,0.0,-1,-1);
    AddStaticVehicle(460,-2412.2446289063,2312.1252441406,1.7003378868103,182.62005615234,-1,-1);
    AddStaticVehicle(473,-2325.9970703125,2331.232421875,0.0,180.63500976563,-1,-1);
    AddStaticVehicle(473,-2326.1667480469,2322.6223144531,0.0,179.36492919922,-1,-1);
    AddStaticVehicle(473,-2326.0747070313,2314.3791503906,0.0,177.37994384766,-1,-1);
    AddStaticVehicle(484,-2324.9133300781,2303.1164550781,0.0,180.63500976563,-1,-1);
    AddStaticVehicle(493,-2229.8403320313,2390.8950195313,0.0,44.420043945313,-1,-1);
    AddStaticVehicle(446,-2222.9406738281,2398.626953125,0.0,45.125,-1,-1);
    AddStaticVehicle(452,-2210.9694824219,2413.1677246094,0.0,45.655029296875,-1,-1);
    AddStaticVehicle(453,-2258.3110351563,2418.888671875,0.0,225.2900390625,-1,-1);
    AddStaticVehicle(454,-2252.9106445313,2429.97265625,0.0,224.30505371094,-1,-1);
    AddStaticVehicle(446,-2240.4770507813,2441.8032226563,0.0,225.5400390625,-1,-1);
    AddStaticVehicle(493,-2202.9836425781,2419.2795410156,0.0,44.905029296875,-1,-1);
    AddStaticVehicle(484,-2233.8278808594,2450.384765625,0.0,226.01995849609,-1,-1);
    AddStaticVehicle(580,-2252.2719726563,2284.8017578125,4.7277369499207,89.045043945313,-1,-1);
    AddStaticVehicle(420,-2271.4165039063,2297.4968261719,4.6702132225037,91.31005859375,-1,-1);
    AddStaticVehicle(420,-2252.9353027344,2317.9926757813,4.6624999046326,268.68994140625,-1,-1);
    AddStaticVehicle(409,-2271.5239257813,2306.5783691406,4.7452130317688,90.325012207031,-1,-1);
    AddStaticVehicle(506,-2271.208984375,2324.3110351563,4.6046133041382,89.825012207031,-1,-1);
    AddStaticVehicle(560,-2252.8239746094,2302.9851074219,4.6174750328064,272.65997314453,-1,-1);
    AddStaticVehicle(411,-2252.8542480469,2332.998046875,4.6124997138977,268.68994140625,-1,-1);
    AddStaticVehicle(555,-2271.0002441406,2327.8669433594,4.5928740501404,91.31005859375,-1,-1);
    AddStaticVehicle(461,-2270.5478515625,2315.4929199219,4.5099239349365,87.340087890625,-1,-1);
    AddStaticVehicle(471,-2270.2788085938,2291.8371582031,4.3952131271362,91.31005859375,-1,-1);
    AddStaticVehicle(471,-2251.5949707031,2293.9479980469,4.3874998092651,89.325012207031,-1,-1);
    AddStaticVehicle(581,-2253.0043945313,2323.9064941406,4.5122609138489,274.64501953125,-1,-1);
    AddStaticVehicle(586,-2271.4533691406,2336.4958496094,4.4095001220703,89.325012207031,-1,-1);
    AddStaticVehicle(522,-2252.3344726563,2309.2976074219,4.4695138931274,274.64501953125,-1,-1);
    AddStaticVehicle(522,-2479.7399902344,2223.501953125,4.5007638931274,0.0,-1,-1);
    AddStaticVehicle(522,-2479.8713378906,2243.2609863281,4.5007638931274,0.0,-1,-1);
    AddStaticVehicle(522,-2453.3344726563,2242.6379394531,4.4342660903931,0.0,-1,-1);
    AddStaticVehicle(560,-2446.6127929688,2241.8996582031,4.6487250328064,0.0,-1,-1);
    AddStaticVehicle(558,-2485.5737304688,2242.708984375,4.5475416183472,0.0,-1,-1);
    AddStaticVehicle(587,-2443.6481933594,2224.5402832031,4.6537499427795,0.0,-1,-1);
    AddStaticVehicle(411,-2452.7268066406,2223.7255859375,4.6437497138977,0.0,-1,-1);
    AddStaticVehicle(411,-2461.3894042969,2224.0258789063,4.6437497138977,0.0,-1,-1);
    AddStaticVehicle(411,-2464.7490234375,2224.1188964844,4.6437497138977,0.0,-1,-1);
    AddStaticVehicle(559,-2473.4890136719,2223.7526855469,4.5978136062622,0.0,-1,-1);
    AddStaticVehicle(559,-2485.5844726563,2223.9975585938,4.6014561653137,0.0,-1,-1);
    AddStaticVehicle(403,-2410.1499023438,2501.4792480469,13.229969978333,270.67492675781,-1,-1);

	//дуэли by Kroks_rus
	print("\n--------------------------------------");
	print(" kroks's duel script has STARTED\n ");
	print(" 28.12.2009 v1.5\n ");
	print("--------------------------------------\n");
	gduel=0;
	CreateObject(3287,2562.164,2828.152,14.559,0.0,0.0,-11.250); // object
	CreateObject(16641,2577.074,2828.747,11.575,0.0,0.0,0.0); // object (8)
	CreateObject(14407,2600.830,2815.637,10.063,0.0,0.0,0.0); // object (9)
	CreateObject(12985,2597.506,2807.310,16.419,0.0,0.0,-90.000); // object (11)
	CreateObject(16082,2566.384,2815.662,13.743,0.0,0.0,0.0); // object (13)
	CreateObject(1466,2584.813,2822.782,10.985,0.0,0.0,90.000); // object (14)
	CreateObject(1469,2584.721,2819.938,10.984,0.0,0.0,-90.000); // object (15)
	CreateObject(1469,2584.620,2817.271,10.984,0.0,0.0,-90.000); // object (16)
	CreateObject(1465,2584.706,2814.594,10.985,0.0,0.0,-90.000); // object (18)
	CreateObject(4726,2572.246,2826.726,26.242,0.0,0.0,0.0); // object (20)
	CreateObject(974,2539.480,2823.161,12.598,0.0,0.0,90.000); // object (21)
	CreateObject(974,2616.175,2830.775,12.548,0.0,0.0,-90.000); // object (22)
	CreateObject(3550,-1421.994,492.113,4.406,0.0,0.0,0.0); // object (14)
	CreateObject(3550,-1421.995,498.090,4.406,0.0,0.0,0.0); // object (15)
	CreateObject(3550,-1386.104,496.476,4.411,0.0,0.0,0.0); // object (16)
	CreateObject(5064,-1567.359,535.677,34.344,0.0,5.157,36.328); // zd
	CreateObject(1612,-1326.289,570.964,3.494,0.0,0.0,-78.750); // object (20)
	CreateObject(3565,-1334.891,488.031,11.493,0.0,0.0,0.0); // object (28)
	CreateObject(3565,-1334.892,488.047,14.191,0.0,0.0,0.0); // object (29)
	CreateObject(3565,-1323.802,514.627,11.529,0.0,0.0,0.0); // object (30)
	CreateObject(3565,-1323.860,514.658,14.226,0.0,0.0,0.0); // object (31)
	CreateObject(3565,-1366.758,515.475,11.545,0.0,0.0,0.0); // object (32)
	CreateObject(12859,-1422.389,510.284,8.443,0.0,0.0,-90.000); // object (42)
	CreateObject(8335,-1453.422,501.978,12.999,0.0,0.0,180.000); // object (44)
	CreateObject(3550,-1350.367,498.340,12.635,0.0,0.0,0.0); // object (45)
	CreateObject(3550,-1374.687,1493.173,3.219,0.0,0.0,0.0); // object (46)
    //дуэли by Kroks_rus

	#if defined Teams
		format(str,sizeof(str),"Teams: %d",Teams);
		WriteToLog(str);
	#endif
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	WriteToLog("Gamemode started!");
	#if defined TimeCycle
		SetTimer("WorldTimeUpdate",60000,1);
	#endif
	SetTimer("SaveAllPlayers",1800000,1);
	#if defined RestrictedAreas
		SetTimer("AreasCheck",1000,1);
	#endif
	#if defined RestrictedAreas
		SetTimer("AreasCheckNew",1000,1);
	#endif
	#if defined IdleTimeToKick
		SetTimer("IdleCheck",60000,1);
	#endif
	#if defined FloodInterval && defined FloodLines
	    SetTimer("FloodCheck",FloodInterval*1000,1);
	#endif
	SetTimer("DeletiAFKLebelT",DeleteAFKInterval*1000,1);
	SetTimer("MoneyCheck",10000,1);
	SetTimer("MoneyForPlay",60000,1);
    SetTimer("OnPlayerToPlayerDistance",3*1000,1);
	AllowAdminTeleport(1);
	AllowInteriorWeapons(0);
	UsePlayerPedAnims();
	#if defined IrcOnOff
	printf("*** IRC: стартуем........");//IRC
	gIRC_pass="jrutteamm";
	SetTimerEx("IRC_ConnectDelay", 2000, 0, "d", 1);//IRC
	gGroupID = IRC_CreateGroup();//IRC
	#endif
	return 1;
}

public OnGameModeExit() {
	SaveAllPlayers();
	WriteToLog("Gamemode exit...");
	#if defined IrcOnOff
	IRC_Quit(gBotID[0], "Отключение мода");
	IRC_DestroyGroup(gGroupID);
	#endif
	return 0;
}
new gBotsInGame;
public OnPlayerConnect(playerid) {
    new str[MAX_STRING],plrIP[16];
	ClearPlayer(playerid);
	LoadPlayer(playerid);
	/*if(PlayerInfo[playerid][Bans]==1){
	   SendClientMessage(playerid,0xA9C4E4FF,"You are banned from this server.");
       gBansss=1;
	   Ban(playerid);
	}*/
    GetPlayerIp(playerid, plrIP, sizeof(plrIP));
	SendClientMessage(playerid, HelpMsgColor,"Добро пожаловать на Joker GTA SA (russia) sa-mp 0.3");
	if (!dini_Exists(PlayerFile(PlayerInfo[playerid][Name]))) {
	  SendClientMessage(playerid, YellowColor,"Вы не зарегистрированы! Рекомендуем зарегистрировать аккаунт.");
	  SendClientMessage(playerid, YellowColor,"После регистрации вы получаете доступ к фунциям сервера, помощь /help");
	  SendClientMessage(playerid, YellowColor,"У вас будет персональная статистика убийств, сохранения денег и многое другое");
   if(!IsPlayerNPC(playerid)){
        ShowPlayerDialog(playerid,0,DIALOG_STYLE_INPUT,"Регистрация","Введите желаемый пароль","Рег-ция","Отмена");
      }
    }
    #if defined AutoLoggins
	   if(PlayerInfo[playerid][LogginType]==1){
          if(strcmp(plrIP, PlayerInfo[playerid][PlayerIP])){
	         PlayerInfo[playerid][Logged]=true;
	         format(str,sizeof(str),"СЕРВЕР: Автоматический вход. Причина: совпадение ip.");
	         SendClientMessage(playerid,SystemMsgColor,str);
	         SendClientMessage(playerid,ConnectMsgColor,"ПОДСКАЗКА: Функцию автоматического входа можно отключить в настройках профиля.");
	         new name[40],newName[40];
	         GetPlayerName(playerid,name,40);
	         format(newName,sizeof(newName),"%s_(ALogin)",name);
	         SetPlayerName(playerid,newName);
	         SendDeathMessage(INVALID_PLAYER_ID,playerid,201);
	         SetPlayerName(playerid,name);
          }
          if(!strcmp(plrIP, PlayerInfo[playerid][PlayerIP])){
             PlayerInfo[playerid][Logged]=false;
             PlayerInfo[playerid][PlayerIP]=plrIP;
          }
	   }
    #endif
	SendClientMessage(playerid, HelpMsgColor,"Сайт поддержки сервера: www.jru-team.ru");
	if(IsPlayerNPC(playerid)) gBotsInGame++;
	else gPlayersInGame++;
	format(str,sizeof(str),"%s (id: %d) connected to the server",PlayerInfo[playerid][Name],playerid);
	WriteToLog(str);
	if(IsPlayerConnected(playerid) && IsPlayerNPC(playerid)){
	format(str,sizeof(str),"*** %s (id: %d) подключился к серверу.",PlayerInfo[playerid][Name],playerid); for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && playerid != i) SendClientMessage(i,ConnectMsgColor,str);
	#if defined IrcOnOff
	format(str,sizeof(str),"03*** 07%s 02(id: %d) 03подключился к серверу. 14[IP:%s]",PlayerInfo[playerid][Name],playerid,plrIP);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	format(str,sizeof(str),"*** На сервере %d бот(ов). ***",gPlayersInGame); for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && playerid != i) SendClientMessage(i,HelpMsgColor,str);
	#if defined IrcOnOff
	format(str,sizeof(str),"03*** На сервере %d бот(ов). ***",gPlayersInGame);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	}
	if(IsPlayerConnected(playerid) && !IsPlayerNPC(playerid)){
	format(str,sizeof(str),"*** %s (id: %d) подключился к серверу.",PlayerInfo[playerid][Name],playerid); for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && playerid != i) SendClientMessage(i,ConnectMsgColor,str);
	#if defined IrcOnOff
	format(str,sizeof(str),"03*** 07%s 02(id: %d) 03подключился к серверу. 14[IP:%s]",PlayerInfo[playerid][Name],playerid,plrIP);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	format(str,sizeof(str),"*** На сервере %d игрок(ов). ***",gPlayersInGame); for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && playerid != i) SendClientMessage(i,HelpMsgColor,str);}
	#if defined IrcOnOff
	format(str,sizeof(str),"03*** На сервере %d игрок(ов). ***",gPlayersInGame);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	#if !defined AllowBadSymbolsInNicks
		for (new i=0;i<strlen(PlayerInfo[playerid][Name]);i++) {
			if (PlayerInfo[playerid][Name][i] < 'A' || 'Z' < PlayerInfo[playerid][Name][i] < 'a' || 'z' < PlayerInfo[playerid][Name][i]) {
				KickPlayer(playerid,"Недопустимые символы в нике.");
				return 1;
			}
		}
	#endif
	SetPlayerColor(playerid,DefaultPlayerColors[playerid]);
	AllowPlayerTeleport(playerid, 0);
	SetPlayerMapIcon(playerid,1,310.2001,1986.9113,17.6406,5,0); // Zone 51
	return 1;
}

public OnPlayerDisconnect(playerid,reason) {
	new str[MAX_STRING],Reason[MAX_STRING];
	if(IsPlayerNPC(playerid)) gBotsInGame--;
	else gPlayersInGame--;
	format(str,sizeof(str),"%s (id: %d) disconnected from the server",PlayerInfo[playerid][Name],playerid);
	WriteToLog(str);
	switch(reason) { case 0: Reason = "Вылет"; case 1: Reason = "Выход"; case 2: Reason = "Кик/Бан"; }
	format(str,sizeof(str),"*** %s покинул сервер. (%s)",PlayerInfo[playerid][Name],Reason);
	if(!gBansss && !IsPlayerNPC(playerid)){
	for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && i != playerid) SendClientMessage(i,ConnectMsgColor,str);
	#if defined IrcOnOff
	format(str,sizeof(str),"14*** 07%s покинул сервер. (06%s)",PlayerInfo[playerid][Name],Reason);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	format(str,sizeof(str),"*** На сервере осталось %d игрок(ов). ***",gPlayersInGame); for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && playerid != i) SendClientMessage(i,SystemMsgColor,str);
	#if defined IrcOnOff
	format(str,sizeof(str),"14*** На сервере осталось %d игрок(ов). ***",gPlayersInGame);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	}
    if(IsPlayerNPC(playerid)){
    format(str,sizeof(str),"*** На сервере осталось %d бот(ов). ***",gBotsInGame); for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && playerid != i) SendClientMessage(i,SystemMsgColor,str);
    #if defined IrcOnOff
	format(str,sizeof(str),"14*** На сервере осталось %d бот(ов). ***",gBotsInGame);
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	}
	SavePlayer(playerid);
	ClearPlayer(playerid);
	PressedC[playerid]=0;
	for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && PlayerInfo[i][Ignores][playerid]) PlayerInfo[i][Ignores][playerid] = false;

	//дуэли by kroks_rus
	new string[256],name1[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
    GetPlayerName(gplay1, name1, sizeof(name1));
    GetPlayerName(gplay2, name2, sizeof(name2));
	switch(gduel){
	case 1: {
	if (playerid==gplay1){
	gduel=0; }
	}
	case 2: {
	if (playerid==gplay1){
	GivePlayerMoney(gplay2, 10000);
	format(string, sizeof(string), "Игрок %s отключился, поэтому игрок %s победил",name1,name2);
	SendClientMessageToAll(0xFFFF00AA, string);
	gduel=0;
	SetPlayerPos(gplay2,2175.7661,1285.7660,42.2241);
	ResetPlayerWeapons(gplay2);

    shotag(1);

	GivePlayerWeapon(gplay2, 31, 5000);
	SetPlayerHealth(gplay2, 100);
	SpawnPlayer(gplay2);
    KillTimer(gtimm);
	}
	if (playerid==gplay2){
    GivePlayerMoney(gplay1, 10000);
	format(string, sizeof(string), "Игрок %s отключился, поэтому игрок %s победил",name2,name1);
	SendClientMessageToAll(0xFFFF00AA, string);
	gduel=0;

	SetPlayerPos(gplay1,2175.7661,1285.7660,42.2241);
	ResetPlayerWeapons(gplay1);
	GivePlayerWeapon(gplay1, 8, 1);
	SetPlayerHealth(gplay1, 100);
	SpawnPlayer(gplay1);
    shotag(1);
    KillTimer(gtimm);
	}
	}
	}
	//дуэли by kroks_rus
	return 1;
}

public OnPlayerRequestClass(playerid,classid) {
	if (dini_Exists(PlayerFile(PlayerInfo[playerid][Name])) && !PlayerInfo[playerid][Logged]) {
	    new str[MAX_STRING];
        #if defined LoggingTimeout
			SetTimerEx("LoggingTimeoutT",LoggingTimeout*1000,0,"i",playerid);
		#endif
		format(str,sizeof(str),"Этот ник зарегистрирован (%s)",PlayerInfo[playerid][Name]);
		WriteEcho(str,playerid,ErrorMsgColor);
		WriteEcho("Если вы являетесь владельцем аккаунта идентифицируйте себя, используя свой пароль",playerid,ErrorMsgColor);
		WriteEcho("В противном случае, выберети другой псевдоним или свяжитесь с администратором сервера (если вы забыли свой пароль)",playerid,ErrorMsgColor);
		WriteEcho("",playerid,-1,2,1,"Вход","Введите свой пароль","Войти","Отмена");
        SetPlayerColor(playerid,LoggingColor);
		return 0;
	}
	PlayerPlaySound(playerid,1097,0,0,0);
	if (classid < Classes) {
	    SetPlayerInterior(playerid,0);
		SetPlayerPos(playerid,2278.6895,2123.6123,32.8281);
		SetPlayerFacingAngle(playerid,90);
		SetPlayerCameraPos(playerid,2273.6895,2123.6123,32.8281);
		SetPlayerCameraLookAt(playerid,2278.6895,2123.6123,32.8281);
		#if defined Teams
			PlayerInfo[playerid][Team] = -1;
		#endif
		new vehicleid = random(Vehicles);
		while (VehicleInfo[vehicleid][VehicleColor1] != -1 || VehicleInfo[vehicleid][VehicleColor2] != -1) vehicleid = random(Vehicles);
		if (!PlayerInfo[playerid][ModelSet]) PlayerInfo[playerid][ModelSet] = true;
		else PlayerInfo[playerid][Model] = classid;
        SetSpawnInfo(playerid,0,ClassInfo[PlayerInfo[playerid][Model]],VehicleInfo[vehicleid][VehicleSpawnX]+3,VehicleInfo[vehicleid][VehicleSpawnY]+3,VehicleInfo[vehicleid][VehicleSpawnZ],VehicleInfo[vehicleid][VehicleSpawnA],SpawnWeapons[0],SpawnWeapons[1],SpawnWeapons[2],SpawnWeapons[3],SpawnWeapons[4],SpawnWeapons[5]);
	}
	#if defined Teams
		else {
			new players,teammates,str[MAX_STRING];
			for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i)) players++;
			for (new i=0;i<Teams;i++) {
				if (TeamInfo[i][TeamClassStart] <= classid <= TeamInfo[i][TeamClassEnd]) {
					format(str,sizeof(str),"%s ~w~Team",TeamInfo[i][TeamName]);
					teammates = 0;
					for (new j=0;j<MAX_PLAYERS;j++) if (IsPlayerConnected(j) && PlayerInfo[j][Team] == i && j != playerid) teammates++;
					if (teammates < players/2+1) {
						PlayerInfo[playerid][Team] = i;
						SetPlayerInterior(playerid,TeamInfo[i][TeamSpawnInterior]);
						SetPlayerPos(playerid,TeamInfo[i][TeamSpawnX],TeamInfo[i][TeamSpawnY],TeamInfo[i][TeamSpawnZ]);
						SetPlayerFacingAngle(playerid,TeamInfo[i][TeamSpawnA]);
						SetPlayerCameraPos(playerid,TeamInfo[i][TeamSpawnX]+(floatsin(-TeamInfo[i][TeamSpawnA],degrees)*5),TeamInfo[i][TeamSpawnY]+(floatcos(-TeamInfo[i][TeamSpawnA],degrees)*5),TeamInfo[i][TeamSpawnZ]);
						SetPlayerCameraLookAt(playerid,TeamInfo[i][TeamSpawnX],TeamInfo[i][TeamSpawnY],TeamInfo[i][TeamSpawnZ]);
					}
					else strcat(str,"~n~~r~FULL");
					GameTextForPlayer(playerid,str,1000,3);
					break;
				}
			}
		}
	#endif
	return 1;
}

public OnPlayerSpawn(playerid) {
	if(dini_Exists(PlayerFile(PlayerInfo[playerid][Name])) && !PlayerInfo[playerid][Logged]){
       WriteEcho("",playerid,-1,2,1,"Вход","Введите свой пароль","Войти","Отмена");
       return 0;
    }
    if(PlayerInfo[playerid][Jailed]){
       new str[MAX_STRING];
       format(str,sizeof(str),"В прошлый раз вы были посажены в тюрьму администратором на %dмин,",PlayerInfo[playerid][Jailed]);
	   WriteEcho(str,playerid,ErrorMsgColor);
	   SendClientMessage(playerid,ErrorMsgColor," но ушли раньше, и теперь должны досидеть указанный срок.");
	   SetPlayerInterior(playerid,3); SetPlayerPos(playerid,197.6661,173.8179,1003.0234); SetPlayerFacingAngle(playerid,0);
	   TogglePlayerControllable(playerid, 0);
	   PlayerInfo[playerid][JailedTime] = SetTimerEx("UnJailedPlayerT",PlayerInfo[playerid][Jailed]*60000,0,"i",playerid);
	   return 1;
	}
	else {
    SetPlayerInterior(playerid,0);}
	if (PlayerInfo[playerid][SafeDeath]) {
	    SetPlayerPos(playerid,0,0,5);
		return 1;
	}
	if (dini_Exists(PlayerFile(PlayerInfo[playerid][Name])) && !PlayerInfo[playerid][Logged]) {
		KickPlayer(playerid,"Необходимо сначало залогинется, изпользуя команду /login");
		return 0;
	}
	new str[MAX_STRING];
	format(str,sizeof(str),"%s (id: %d) spawned",PlayerInfo[playerid][Name],playerid);
	WriteToLog(str);
	PlayerPlaySound(playerid,1098,0,0,0);
	#if defined Teams
		new team = PlayerInfo[playerid][Team];
		if (team == -1) {
			if (!PlayerInfo[playerid][AdminColored]) SetPlayerColor(playerid,DefaultPlayerColors[playerid]);
			else SetPlayerColor(playerid,AdminColor);
		}
		else {
			if (!PlayerInfo[playerid][AdminColored]) SetPlayerColor(playerid,TeamInfo[team][TeamColor]);
			else SetPlayerColor(playerid,AdminColor);
			SetPlayerInterior(playerid,TeamInfo[team][TeamSpawnInterior]);
		}
	#else
	    if (!PlayerInfo[playerid][AdminColored]) SetPlayerColor(playerid,DefaultPlayerColors[playerid]);
	    else SetPlayerColor(playerid,AdminColor);
	#endif
	#if defined AntiSpawnKillTime
		PlayerInfo[playerid][CanBeKilled] = false;
		PlayerInfo[playerid][AntiSpawnKillTimer] = SetTimerEx("AntiSpawnKill",AntiSpawnKillTime*1000,0,"i",playerid);
	#endif
	for (new i=0;i<WeaponGroups;i++) if (PlayerInfo[playerid][WeaponAmmos][i] > 0) GivePlayerWeapon(playerid,WeaponInfo[PlayerInfo[playerid][WeaponIDs][i]][WeaponID],PlayerInfo[playerid][WeaponAmmos][i]);
	PlayerInfo[playerid][Spawn]=1;
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

public OnPlayerDeath(playerid,killerid,reason) {
	if (PlayerInfo[playerid][SafeDeath]) {
	    PlayerInfo[playerid][SafeDeath] = false;
	    return 1;
	}
	//if(!PlayerInfo[killerid][Logged]){ WriteEcho("Чтобы использовать эту возможность необходимо залогинеться.",killerid,ErrorMsgColor); WriteEcho("",killerid,-1,2,1,"Вход","Введите свой пароль:","Войти","Отмена");}
	new str[MAX_STRING],Float:health,wname[MAX_STRING],vehicleids; vehicleids=GetPlayerVehicleID(killerid);
	SendDeathMessage(killerid,playerid,reason);
	GetPlayerHealth(killerid,health);//GetVehicleModel(GetPlayerVehicleID(killerid))
	switch(vehicleids){
	   case 417,425,447,469,487,488,497,548,563:{
		  if(reason==50 && !IsPlayerInAnyVehicle(playerid)){
			 format(wname,sizeof(wname),"Винт верталета");
          }
	   }
	   default:{
		  if(reason==50 && !IsPlayerInAnyVehicle(playerid)){
			 format(wname,sizeof(wname),"Задавил (дб)");
	      }
	      if(reason==49 && !IsPlayerInAnyVehicle(playerid)){
			 format(wname,sizeof(wname),"Сбил машиной");
	      }
		  else format(wname,sizeof(wname),"%s",GetWeaponNameRu(reason));
       }
	}
    format(str,sizeof(str),"Вас убил %s (id: %d), оружие: %s(%d). У него (нее) осталось %dхп",PlayerInfo[killerid][Name],killerid,wname,reason,floatround(health,floatround_floor));
    WriteEcho(str,playerid,ConnectMsgColor);
	#if defined AntiSpawnKillTime
		KillTimer(PlayerInfo[playerid][AntiSpawnKillTimer]);
	#endif
	#if defined Teams
		if (PlayerInfo[playerid][Team] == -1) {
		    new vehicleid = random(Vehicles);
			while (VehicleInfo[vehicleid][VehicleColor1] != -1 || VehicleInfo[vehicleid][VehicleColor2] != -1) vehicleid = random(Vehicles);
			SetSpawnInfo(playerid,0,ClassInfo[PlayerInfo[playerid][Model]],VehicleInfo[vehicleid][VehicleSpawnX]+3,VehicleInfo[vehicleid][VehicleSpawnY]+3,VehicleInfo[vehicleid][VehicleSpawnZ],VehicleInfo[vehicleid][VehicleSpawnA],SpawnWeapons[0],SpawnWeapons[1],SpawnWeapons[2],SpawnWeapons[3],SpawnWeapons[4],SpawnWeapons[5]);
		}
	#else
	    new vehicleid = random(Vehicles);
		while (VehicleInfo[vehicleid][VehicleColor1] != -1 || VehicleInfo[vehicleid][VehicleColor2] != -1) vehicleid = random(Vehicles);
		SetSpawnInfo(playerid,0,ClassInfo[PlayerInfo[playerid][Model]],VehicleInfo[vehicleid][VehicleSpawnX]+3,VehicleInfo[vehicleid][VehicleSpawnY]+3,VehicleInfo[vehicleid][VehicleSpawnZ],VehicleInfo[vehicleid][VehicleSpawnA],SpawnWeapons[0],SpawnWeapons[1],SpawnWeapons[2],SpawnWeapons[3],SpawnWeapons[4],SpawnWeapons[5]);
	#endif
	if (killerid == INVALID_PLAYER_ID) {
		format(str,sizeof(str),"%s (id: %d) suicided",PlayerInfo[playerid][Name],playerid);
		WriteToLog(str);
		SetPlayerScore(playerid,GetPlayerScore(playerid)-1);
		PlayerInfo[playerid][Suicides]++;
	}
	else {
		format(str,sizeof(str),"%s (id: %d) killed %s (id: %d) with %s (id: %d)",PlayerInfo[killerid][Name],killerid,PlayerInfo[playerid][Name],playerid,WeaponNames[reason],reason);
		WriteToLog(str);
		new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
		GetPlayerPos(playerid,x1,y1,z1);
		GetPlayerPos(killerid,x2,y2,z2);
		#if defined InDoorWeapons
		    if (reason != 0 && z1 > 700 && z2 > 700 && !IsPlayerInAnyVehicle(playerid) && !IsPlayerInAnyVehicle(killerid)) {
		        KickPlayer(killerid,"Убийство в помищении запрещено!");
				return 1;
		    }
		#endif
		new distance = floatround(floatsqroot(floatpower(x2-x1,2)+floatpower(y2-y1,2)+floatpower(z2-z1,2)),floatround_floor);
		#if defined CheatWeapons
			for (new i=0;i<CheatWeapons;i++) {
				if (reason == CheatWeapon[i]) {
					if (reason == 37) {
						PlayerInfo[playerid][CheatDeaths]++;
						if (PlayerInfo[playerid][CheatDeaths] >= DeathsFromCheatToBan) {
							BanPlayer(playerid,"Использовал читы: огнемет");
							return 1;
						}
						if (distance <= LegalKillDistance) {
							PlayerInfo[killerid][CheatKills]++;
							if (PlayerInfo[killerid][CheatKills] >= FlameCheatsToBan) {
								BanPlayer(killerid,"Использовал читы: запрещенное оружие");
								return 1;
							}
						}
					}
					else {
						if (distance > LegalKillDistance) {
							BanPlayer(playerid,"Использовал читы: поддельная смерть");
							return 1;
						}
						PlayerInfo[playerid][CheatDeaths]++;
						if (PlayerInfo[playerid][CheatDeaths] >= DeathsFromCheatToBan) {
							BanPlayer(playerid,"Использовал читы: поддельная смерть");
							return 1;
						}
						BanPlayer(killerid,"Использовал читы: запрещенное оружие");
						return 1;
					}
					break;
				}
			}
		#endif
		if (distance <= LegalKillDistance) {
			#if defined AntiSpawnKillTime
				if (!PlayerInfo[playerid][CanBeKilled]) {
					if (!IsPlayerAdmin(killerid) && PlayerInfo[killerid][Admin] < AdminLevelToIgnorePunishment) {
						SetPlayerScore(killerid,GetPlayerScore(killerid)-1);
						SetPlayerHealth(killerid,0);
					}
					WriteEcho("Нельзя убивать игров на спавне!",killerid,ErrorMsgColor);
					return 1;
				}
			#endif
			new vechicleid; vechicleid=GetVehicleModel(GetPlayerVehicleID(killerid));
			#if defined NoDriveBy
				if(vechicleid!=520 && vechicleid!=425 && vechicleid!=432 && vechicleid!=476){
				if(IsPlayerInAnyVehicle(killerid) && !IsPlayerInAnyVehicle(playerid) && GetPlayerState(killerid) == PLAYER_STATE_DRIVER && !IsPlayerNPC(killerid)) {
					if (!IsPlayerAdmin(killerid) && PlayerInfo[killerid][Admin] < AdminLevelToIgnorePunishment) {
						   SetPlayerScore(killerid,GetPlayerScore(killerid)-2);
						   new string[256];
	                       format(string,256,"Игрок \"%s (id: %d)\" был приговорен сервером к 5мин заключения. Причина: Drive-By",PlayerInfo[killerid][Name],killerid); WriteEcho(string,INVALID_PLAYER_ID,MuteMsgColor);
	                       PlayerInfo[killerid][Jailed] = true; SetPlayerInterior(killerid,3); SetPlayerPos(killerid,197.6661,173.8179,1003.0234); SetPlayerFacingAngle(killerid,0);
	                       PlayerInfo[killerid][Jailed] = 5;
	                       TogglePlayerControllable(killerid, 0);
                           ResetPlayerWeapons(killerid);
	                       PlayerInfo[killerid][JailedTime] = SetTimerEx("UnJailedPlayerT",PlayerInfo[killerid][Jailed]*60000,0,"i",killerid);

				}
					WriteEcho("Нельзя убивать путем наезда транспортом и/или стреляя из авто!",killerid,ErrorMsgColor);
					return 1;
				}
				}
			#endif
            //инфа для админов что игрок убит с апатча
			if (GetPlayerState(killerid) == PLAYER_STATE_DRIVER && GetVehicleModel(GetPlayerVehicleID(killerid))==425 && reason==38){
			   format(str,sizeof(str),"%s (id: %d) убил %s (id: %d). Оружие: Вертолет Апач.",PlayerInfo[killerid][Name],killerid,PlayerInfo[playerid][Name],playerid);
               for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid && i != killerid) WriteEcho(str,i,AdminChatColor);
			}
			#if defined Teams
				#if defined NoTeamKill
					if (PlayerInfo[killerid][Team] > -1 && PlayerInfo[killerid][Team] == PlayerInfo[playerid][Team]) {
						if (!IsPlayerAdmin(killerid) && PlayerInfo[killerid][Admin] < AdminLevelToIgnorePunishment) {
							SetPlayerScore(killerid,GetPlayerScore(killerid)-2);
							new string[256];
	                        format(string,256,"Игрок \"%s (id: %d)\" был приговорен сервером к 5мин заключения. Причина: Team KILL",PlayerInfo[killerid][Name],killerid); WriteEcho(string,INVALID_PLAYER_ID,MuteMsgColor);
	                        PlayerInfo[killerid][Jailed] = true; SetPlayerInterior(killerid,3); SetPlayerPos(killerid,197.6661,173.8179,1003.0234); SetPlayerFacingAngle(killerid,0);
	                        PlayerInfo[killerid][Jailed] = 5;
	                        TogglePlayerControllable(killerid, 0);
                            ResetPlayerWeapons(killerid);
	                        PlayerInfo[killerid][JailedTime] = SetTimerEx("UnJailedPlayerT",PlayerInfo[killerid][Jailed]*60000,0,"i",killerid);
						}
						WriteEcho("Нельзя убивать игроков с которыми появляешься на одном спавне!",killerid,ErrorMsgColor);
						return 1;
					}
				#endif
			#endif
		}
		SetPlayerScore(killerid,GetPlayerScore(killerid)+1);
		PlayerInfo[killerid][Kills]++;
		PlayerInfo[killerid][CurrentKillsForLife]++;
		if (PlayerInfo[killerid][CurrentKillsForLife] > PlayerInfo[killerid][MaxKillsForLife]) PlayerInfo[killerid][MaxKillsForLife] = PlayerInfo[killerid][CurrentKillsForLife];
		GiveMoney(killerid,MoneysForKill*PlayerInfo[killerid][CurrentKillsForLife]);
	}
	PlayerInfo[playerid][Deaths]++;
	PlayerInfo[playerid][CurrentKillsForLife] = 0;
	if (PlayerInfo[playerid][Moneys]-MoneysForKill > 0) GiveMoney(playerid,-MoneysForKill);
	else GiveMoney(playerid,-GetPlayerMoney(playerid));
	if (killerid != INVALID_PLAYER_ID){
	   format(str, sizeof(str), "04*** %s убил %s. (%s)",PlayerInfo[killerid][Name],PlayerInfo[playerid][Name],GetWeaponNameRu(reason));
	}
	else {
	   switch (reason)
	   {
	      case 53:{format(str, sizeof(str), "04*** %s умер. (Drowned)", PlayerInfo[playerid][Name]);}
		  case 54:{format(str, sizeof(str), "04*** %s умер. (Collision)", PlayerInfo[playerid][Name]);}
		  default:{format(str, sizeof(str), "04*** %s умер.", PlayerInfo[playerid][Name]);}
	   }
	}
	#if defined IrcOnOff
	IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	#endif
	Delete3DTextLabel(PlayerInfo[playerid][AFKMsg]);
	Delete3DTextLabel(PlayerInfo[killerid][AFKMsg]);
	
	//дуэли by kroks_rus
	//new string[256],name1[MAX_PLAYER_NAME],name2[MAX_PLAYER_NAME];
	if (gduel==2){
    /*GetPlayerName(gplay1, name1, sizeof(name1));
    GetPlayerName(gplay2, name2, sizeof(name2));*/
    /*PlayerInfo[gplay1][DuelCreate] = 0;
	PlayerInfo[gplay2][DuelChange] = 0;*/
	/* Если 2 игрока */
	if (playerid==gplay1){
		if (killerid==gplay2){
		   GivePlayerMoney(gplay2, 2500);
		   format(str, sizeof(str), "Игрок %s победил игрока %s !",PlayerInfo[gplay2][Name],PlayerInfo[gplay1][Name]);
		   giverep(gplay2,1);
		   giverep(gplay1,-1);
		   WriteEcho(str);
		   gduel=0;
		   gDuelTetATet=0;
		   ResetPlayerWeapons(gplay2);
		   SpawnPlayer(gplay2);
       	   SetPlayerMarkerForPlayer(gplay1, gplay2, 1);
		   SetPlayerMarkerForPlayer(gplay2, gplay1, 1);
		   SetPlayerHealth(gplay2, 100);
           KillTimer(gtimm);
		   shotag(1);
		}
		else {
		   format(str, sizeof(str), "Игрока %s в дуэли убил не %s !",PlayerInfo[gplay1][Name],PlayerInfo[gplay2][Name]);
		   WriteEcho(str);
           ResetPlayerWeapons(gplay2);
       	   SetPlayerMarkerForPlayer(gplay1, gplay2, 1);
		   SetPlayerMarkerForPlayer(gplay2, gplay1, 1);
           gduel=0;
           gDuelTetATet=0;
           SpawnPlayer(gplay2);
           KillTimer(gtimm);
           shotag(1);
		}
		PlayerInfo[gplay1][DuelCreate] = 0;
	    PlayerInfo[gplay2][DuelCreate] = 0;
	    PlayerInfo[gplay1][DuelChange] = 0;
	    PlayerInfo[gplay2][DuelChange] = 0;
	}
	if (playerid==gplay2){
		if (killerid==gplay1){
		   GivePlayerMoney(gplay1, 2500);
		   format(str, sizeof(str), "Игрок %s победил игрока %s !",PlayerInfo[gplay1][Name],PlayerInfo[gplay2][Name]);
           giverep(gplay1,1);
		   giverep(gplay2,-1);
		   WriteEcho(str);
		   gduel=0;
		   gDuelTetATet=0;
           ResetPlayerWeapons(gplay1);
       	   SetPlayerMarkerForPlayer(gplay1, gplay2, 1);
		   SetPlayerMarkerForPlayer(gplay2, gplay1, 1);
		   SetPlayerHealth(gplay1, 100);
		   SpawnPlayer(gplay1);
           KillTimer(gtimm);
           shotag(1);
		}
		else {
		   format(str, sizeof(str), "Игрока %s в дуэли убил не %s !",PlayerInfo[gplay2][Name],PlayerInfo[gplay1][Name]);
		   WriteEcho(str);
           ResetPlayerWeapons(gplay1);
           gduel=0;
           gDuelTetATet=0;
       	   SetPlayerMarkerForPlayer(gplay1, gplay2, 1);
		   SetPlayerMarkerForPlayer(gplay2, gplay1, 1);
           SpawnPlayer(gplay1);
		   KillTimer(gtimm);
           shotag(1);
		}
		PlayerInfo[gplay1][DuelCreate] = 0;
	    PlayerInfo[gplay2][DuelCreate] = 0;
	    PlayerInfo[gplay1][DuelChange] = 0;
	    PlayerInfo[gplay2][DuelChange] = 0;
	}
	}
    //дуэли by kroks_rus
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
   if ((GetVehicleModel(vehicleid)==425||GetVehicleModel(vehicleid)==432||GetVehicleModel(vehicleid)==520)){
      SendClientMessage(playerid, ErrorMsgColor, "Внимание. Перемещаться в этой технике за пределами базы запрещено");
   }
   return 1;
}

public OnPlayerText(playerid,text[]) {
	if (!IsPlayerConnected(playerid)) return 0;
	if(!PlayerInfo[playerid][Logged]){ WriteEcho("Чтобы использовать эту возможность необходимо залогинеться.",playerid,ErrorMsgColor); WriteEcho("",playerid,-1,2,1,"Вход","Введите свой пароль:","Войти","Отмена");}
	#if defined FloodInterval && defined FloodLines
	    if (!IsPlayerAdmin(playerid) && PlayerInfo[playerid][Admin] < AdminLevelToIgnorePunishment) {
	    	PlayerInfo[playerid][Messages]++;
	    	if (PlayerInfo[playerid][Messages] > FloodLines) {
	    	    PlayerInfo[playerid][Messages] = 0;
				KickPlayer(playerid,"Стоп Флуд!");
	            return 0;
	    	}
		}
	#endif
	if (dini_Exists(PlayerFile(PlayerInfo[playerid][Name])) && !PlayerInfo[playerid][Logged]) return 0;
	FixChars(text);
	new str[MAX_STRING],targetid = PlayerInfo[playerid][Query];
	if (text[0] == '!' && targetid != playerid && IsPlayerConnected(targetid)) {
		text[0] = ' ';
		format(str,sizeof(str),"%s (id: %d) sent PM to %s (id: %d):%s",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,text);
		WriteToLog(str);
		if (!IsPlayerAdmin(playerid) && PlayerInfo[playerid][Admin] == 0 && !IsPlayerAdmin(targetid) && PlayerInfo[targetid][Admin] == 0) for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && PlayerInfo[i][Admin] > PlayerInfo[playerid][Admin] && PlayerInfo[i][Admin] > PlayerInfo[targetid][Admin] && PlayerInfo[i][HearAll]) WriteEcho(str,i,PrivateMsgColor);
		format(str,sizeof(str),"ПМ для %s (id: %d):%s",PlayerInfo[targetid][Name],targetid,text);
		WriteEcho(str,playerid,PrivateMsgColor);
		if (PlayerInfo[targetid][Ignores][playerid]) return 0;
		format(str,sizeof(str),"ПМ от %s (id: %d):%s",PlayerInfo[playerid][Name],playerid,text);
		WriteEcho(str,targetid,PrivateMsgColor);
		return 0;
	}
	if (text[0] == '+' && (IsPlayerAdmin(playerid) || PlayerInfo[playerid][Admin] > 0)) {
		text[0] = ' ';
		format(str,sizeof(str),"%s (id: %d) админам:%s",PlayerInfo[playerid][Name],playerid,text);
		WriteToLog(str);
		#if defined AdminsLog
			WriteToLog(str,AdminsLog);
		#endif
		for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0)) WriteEcho(str,i,AdminChatColor);
		return 0;
	}
	if (PlayerInfo[playerid][Mute]) {
		format(str,sizeof(str),"Muted message: %s (id: %d): %s",PlayerInfo[playerid][Name],playerid,text);
		WriteToLog(str);
		WriteEcho("Тебе было запрещено чатится.",playerid,ErrorMsgColor);
		return 0;
	}
	#if defined Teams
		new team = PlayerInfo[playerid][Team];
		if (text[0] == '*' && team > -1) {
			text[0] = ' ';
			format(str,sizeof(str),"%s (id: %d) команде %s (id: %d):%s",PlayerInfo[playerid][Name],playerid,TeamInfo[team][TeamName],team,text);
			for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && PlayerInfo[i][HearAll] && team != PlayerInfo[i][Team]) WriteEcho(str,i,TeamInfo[team][TeamColor]);
			format(str,sizeof(str),"%s (id: %d) to team:%s",PlayerInfo[playerid][Name],playerid,text);
			WriteToLog(str);
			for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && team == PlayerInfo[i][Team]) WriteEcho(str,i,TeamInfo[team][TeamColor]);
			return 0;
		}
	#endif
	if(PlayerInfo[playerid][AFK]){
	   format(str,sizeof(str),"*AFK* %s (id: %d): %s",PlayerInfo[playerid][Name],playerid,text[0]);
	   SendClientMessageToAll(COLOR_LIGHTBLUE,str);
	   return 0;
	}
	format(str,sizeof(str),"%s (id: %d): %s",PlayerInfo[playerid][Name],playerid,text);
	WriteToLog(str);
	#if defined SolidColorChat
		new color;
		if (!PlayerInfo[playerid][AdminColored]) {
	    	#if defined Teams
	        	if (team > -1) color = TeamInfo[team][TeamColor];
				else color = DefaultPlayerColors[playerid];
			#else
		    	color = DefaultPlayerColors[playerid];
			#endif
		}
		else color = AdminColor;
		for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && !PlayerInfo[i][Ignores][playerid]) WriteEcho(str,i,color);
		return 0;
	#endif
    format(str,sizeof(str),"(id: %d): %s",playerid,text[0]);
    SendPlayerMessageToAll(playerid,str);
    #if defined IrcOnOff
    if(!gBotNoSay){
	   format(str, sizeof(str), "07%s 01(id: %d): %s",PlayerInfo[playerid][Name],playerid,text[0]);
	   IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	   gBotNoSay=1;
	   SetTimerEx("AntiFloodInIRC",IRCFloodInterval*1000,0,"i");
	}
	#endif
	return 0;
}

#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1

dcmd_help(playerid,params[]) {
	#pragma unused params
	WriteEcho("SimpleDM 0.3 by ProRaiL. Update to 1.2 by JRU Team,",playerid);
	WriteEcho("[JRU]S_S(icq:2622124) & [JRU]kroks_rus (icq:466237940). Tested [JRU]zoltan",playerid);
	WriteEcho("ОШИБКА: Данная команда не совместима с этой версией мода.",playerid,ErrorMsgColor);
	WriteEcho("СПРАВКА: воспользуйтесь командой /me или нажмите клавишу \"Tab\" и кликнете по своему нику в списке игроков",playerid,HelpMsgColor);
	WriteEcho("Так же данное меню доступно при нажатии сочетания клавишь \"Alt+num1\"",playerid,HelpMsgColor);
	WriteEcho("ИНФО: Обязательно посетите сайт и форум сервера: www.jru-team.ru",playerid);
	return 1;
}
dcmd_h(playerid,params[]) {
    dcmd_help(playerid,params);
	return 1;
}

dcmd_commands(playerid,params[]) {
	#pragma unused params
	WriteEcho("ОШИБКА: Данная команда не совместима с этой версией мода.",playerid,ErrorMsgColor);
	WriteEcho("СПРАВКА: воспользуйтесь командой /me или нажмите клавишу \"Tab\" и кликнете по своему нику в списке игроков",playerid,HelpMsgColor);
	WriteEcho("Так же данное меню доступно при нажатии сочетания клавишь \"Alt+num1\"",playerid,HelpMsgColor);
	WriteEcho("ИНФО: Обязательно посетите сайт и форум сервера: www.jru-team.ru",playerid);
	return 1;
}
dcmd_c(playerid,params[]) {
    dcmd_commands(playerid,params);
	return 1;
}

dcmd_register(playerid,params[]) {
	new str[MAX_STRING];
	if (dini_Exists(PlayerFile(PlayerInfo[playerid][Name]))) {
		format(str,sizeof(str),"Этот ник зарегестрирован (%s)",PlayerInfo[playerid][Name]);
		WriteEcho(str,playerid,ErrorMsgColor);
		return 1;
	}
	new tmp[MAX_STRING],idx;
	tmp = strtok(params,idx);
	if (!strlen(tmp)) {
		WriteEcho("Используй: /register <пароль>",playerid,HelpMsgColor);
		return 1;
	}
	if (strlen(tmp) < 5) {
		WriteEcho("Пароль должен состоять минимум из 5 символов",playerid,ErrorMsgColor);
		return 1;
	}
	dini_Create(PlayerFile(PlayerInfo[playerid][Name]));
	PlayerInfo[playerid][Password] = num_hash(tmp);
	PlayerInfo[playerid][Logged] = true;
	SavePlayer(playerid);
	format(str,sizeof(str),"%s (id: %d) registered an account",PlayerInfo[playerid][Name],playerid);
	WriteToLog(str);
	format(str,sizeof(str),"* Ты зарегистрировал свой ник (%s)! В дальнейшем используй /login %s для входа в свой аккунант",PlayerInfo[playerid][Name],tmp);
	//WriteEcho(str,playerid);
    SendClientMessage(playerid,0xFFFF00AA,str);
	return 1;
}

dcmd_login(playerid,params[]) {
	new str[MAX_STRING];
	if (!dini_Exists(PlayerFile(PlayerInfo[playerid][Name]))) {
		format(str,sizeof(str),"Этот ник (%s) не зарегестрирован. Зарегестрируйся с помощь команды /register",PlayerInfo[playerid][Name]);
		WriteEcho(str,playerid,ErrorMsgColor);
		return 1;
	}
	new tmp[MAX_STRING],idx;
	tmp = strtok(params,idx);
	if (!strlen(tmp)) {
		WriteEcho("Используй: /login <пароль>",playerid,HelpMsgColor);
		return 1;
	}
	if (PlayerInfo[playerid][Logged]) {
		WriteEcho("Ты уже вошел(а)",playerid,ErrorMsgColor);
		return 1;
	}
	if (PlayerInfo[playerid][Password] != num_hash(tmp)) {
		PlayerInfo[playerid][WrongPasswords]++;
		if (PlayerInfo[playerid][WrongPasswords] > 5) {
			KickPlayer(playerid,"Не верный пароль");
			return 1;
		}
		format(str,sizeof(str),"%s (id: %d) typed wrong password",PlayerInfo[playerid][Name],playerid);
		WriteToLog(str);
		for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
		format(str,sizeof(str),"Ты ввел(а) не верный пароль (%s)",tmp,PlayerInfo[playerid][WrongPasswords]);
		WriteEcho(str,playerid,ErrorMsgColor);
		return 1;
	}
	PlayerInfo[playerid][Logged] = true;
	format(str,sizeof(str),"%s (id: %d) logged in",PlayerInfo[playerid][Name],playerid);
	WriteToLog(str);
	WriteEcho("Ты вошел(а).",playerid);
	PlayerInfo[playerid][SafeDeath] = true;
	SetSpawnInfo(playerid,0,0,0,0,5,0,0,0,0,0,0,0);
	SpawnPlayer(playerid);
	SetPlayerCameraPos(playerid,1481.4418,-1795.4611,156.7533);
	SetPlayerCameraLookAt(playerid,1481.4418,-1790.4611,156.7533);
	SetPlayerHealth(playerid,0);
	SetPlayerColor(playerid,DefaultPlayerColors[playerid]-0xFF);
	SendDeathMessage(INVALID_PLAYER_ID,playerid,201);
	return 1;
}
dcmd_l(playerid,params[]) {
	dcmd_login(playerid,params);
	return 1;
}

dcmd_changepassword(playerid,params[]) {
    #pragma unused params
	WriteEcho("ОШИБКА: Данная команда не совместима с этой версией мода.",playerid,ErrorMsgColor);
	WriteEcho("СПРАВКА: воспользуйтесь командой /me или нажмите клавишу \"Tab\" и кликнете по своему нику в списке игроков",playerid,HelpMsgColor);
	WriteEcho("Так же данное меню доступно при нажатии сочетания клавишь \"Alt+num1\"",playerid,HelpMsgColor);
	WriteEcho("ИНФО: Обязательно посетите сайт и форум сервера: www.jru-team.ru",playerid);
	return 1;
}

dcmd_stats(playerid,params[]) {
	new str[MAX_STRING],tmp[MAX_STRING],idx;
	tmp = strtok(params,idx);
	if (!strlen(tmp)) {
		format(str,sizeof(str),"Твоя статистика (%s):",PlayerInfo[playerid][Name]);
		WriteEcho(str,playerid);
		format(str,sizeof(str),"Денег: %d",GetPlayerMoney(playerid));
		WriteEcho(str,playerid,HelpMsgColor);
		format(str,sizeof(str),"Убийств: %d",PlayerInfo[playerid][Kills]);
		WriteEcho(str,playerid,HelpMsgColor);
		format(str,sizeof(str),"Максимум убийств за жизнь: %d",PlayerInfo[playerid][MaxKillsForLife]);
		WriteEcho(str,playerid,HelpMsgColor);
		format(str,sizeof(str),"Смертей: %d",PlayerInfo[playerid][Deaths]);
		WriteEcho(str,playerid,HelpMsgColor);
		format(str,sizeof(str),"Самоубийств: %d",PlayerInfo[playerid][Suicides]);
		WriteEcho(str,playerid,HelpMsgColor);
		if (PlayerInfo[playerid][Deaths] > 0) {
			new Float:ratio = floatdiv(PlayerInfo[playerid][Kills],PlayerInfo[playerid][Deaths]);
			format(str,sizeof(str),"Соотношение убийство/смерть: %f",ratio);
			WriteEcho(str,playerid,HelpMsgColor);
		}
	}
	else {
		new targetid = GetPlayerID(tmp);
		if (targetid != INVALID_PLAYER_ID) {
			format(str,sizeof(str),"Статистика %s (id: %d):",PlayerInfo[targetid][Name],targetid);
			WriteEcho(str,playerid);
			format(str,sizeof(str),"Денег: %d",GetPlayerMoney(targetid));
			WriteEcho(str,playerid,HelpMsgColor);
			format(str,sizeof(str),"Убийств: %d",PlayerInfo[targetid][Kills]);
			WriteEcho(str,playerid,HelpMsgColor);
			format(str,sizeof(str),"Максимум убийств за жизнь: %d",PlayerInfo[targetid][MaxKillsForLife]);
			WriteEcho(str,playerid,HelpMsgColor);
			format(str,sizeof(str),"Смертей: %d",PlayerInfo[targetid][Deaths]);
			WriteEcho(str,playerid,HelpMsgColor);
			format(str,sizeof(str),"Самоубийств: %d",PlayerInfo[targetid][Suicides]);
			WriteEcho(str,playerid,HelpMsgColor);
			if (PlayerInfo[targetid][Deaths] > 0) {
				new Float:ratio = floatdiv(PlayerInfo[targetid][Kills],PlayerInfo[targetid][Deaths]);
				format(str,sizeof(str),"Соотношение убийство/смерть: %f",ratio);
				WriteEcho(str,playerid,HelpMsgColor);
			}
		}
		else {
			new filename[MAX_STRING];
			filename = PlayerFile(tmp);
			if (!dini_Exists(filename)) {
 				format(str,sizeof(str),"Ник не найден (%s)",tmp);
				WriteEcho(str,playerid,ErrorMsgColor);
				return 1;
			}
			format(str,sizeof(str),"Статистика %s:",tmp);
			WriteEcho(str,playerid);
			format(str,sizeof(str),"Денег: %d",dini_Int(filename,"Moneys"));
			WriteEcho(str,playerid,HelpMsgColor);
			format(str,sizeof(str),"Убийств: %d",dini_Int(filename,"Kills"));
			WriteEcho(str,playerid,HelpMsgColor);
			format(str,sizeof(str),"Максимум убийств за жизнь: %d",dini_Int(filename,"MaxKillsForLife"));
			WriteEcho(str,playerid,HelpMsgColor);
			format(str,sizeof(str),"Смертей: %d",dini_Int(filename,"Deaths"));
			WriteEcho(str,playerid,HelpMsgColor);
			format(str,sizeof(str),"Самоубийств: %d",dini_Int(filename,"Suicides"));
			WriteEcho(str,playerid,HelpMsgColor);
			new deaths = dini_Int(filename,"Deaths");
			if (deaths > 0) {
				new Float:ratio = floatdiv(dini_Int(filename,"Kills"),deaths);
				format(str,sizeof(str),"Соотношение убийство/смерть: %f",ratio);
				WriteEcho(str,playerid,HelpMsgColor);
			}
		}
	}
	return 1;
}
dcmd_s(playerid,params[]) {
	dcmd_stats(playerid,params);
	return 1;
}

dcmd_query(playerid,params[]) {
	new tmp[MAX_STRING],idx;
	tmp = strtok(params,idx);
	if (!strlen(tmp)) {
		WriteEcho("Используй: /query <playerid>",playerid,HelpMsgColor);
		return 1;
	}
	new targetid = strval(tmp);
	if (targetid == playerid) {
		WriteEcho("You cannot query yourself",playerid,ErrorMsgColor);
		return 1;
	}
	new str[MAX_STRING];
	if (!IsPlayerConnected(targetid)) {
		format(str,sizeof(str),"You cannot query offline players (%d)",targetid);
		WriteEcho(str,playerid,ErrorMsgColor);
		return 1;
	}
	PlayerInfo[playerid][Query] = targetid;
	format(str,sizeof(str),"Теперь вы можите писать ПМ игроку \"%s\" (id: %d) используя символ \"!\" перед текстом",PlayerInfo[targetid][Name],targetid);
	WriteEcho(str,playerid);
	return 1;
}

dcmd_ignore(playerid,params[]) {
	new tmp[MAX_STRING],idx;
	tmp = strtok(params,idx);
	if (!strlen(tmp)) {
		WriteEcho("Используй: /ignore <playerid>",playerid,HelpMsgColor);
		return 1;
	}
	new targetid = strval(tmp);
	if (targetid == playerid) {
		WriteEcho("Нельзя игнорировать себя",playerid,ErrorMsgColor);
		return 1;
	}
	new str[MAX_STRING];
	if (!IsPlayerConnected(targetid)) {
		format(str,sizeof(str),"Нельзя игнорировать несуществующих игроков (%d)",targetid);
		WriteEcho(str,playerid,ErrorMsgColor);
		return 1;
	}
	if (!PlayerInfo[playerid][Ignores][targetid]) {
		PlayerInfo[playerid][Ignores][targetid] = true;
		format(str,sizeof(str),"Ты добавил(а) %s (id: %d) в свой игнор лист.",PlayerInfo[targetid][Name],targetid);
		WriteEcho(str,playerid);
		format(str,sizeof(str),"Чтобы удалить его(её) из игнор листа снова введи /ignore %d",targetid);
		WriteEcho(str,playerid);
	}
	else {
		PlayerInfo[playerid][Ignores][targetid] = false;
		format(str,sizeof(str),"Ты удалил(а) %s (id: %d) из своего игнор листа.",PlayerInfo[targetid][Name],targetid);
		WriteEcho(str,playerid);
	}
	return 1;
}

dcmd_weaponlist(playerid,params[]) {
	#pragma unused params
	AllPlayerMenu("buygan",playerid);
	return 1;
}
dcmd_w(playerid,params[]) {
	dcmd_weaponlist(playerid,params);
	return 1;
}

dcmd_buy(playerid,params[]) {
    #pragma unused params
	AllPlayerMenu("buygan",playerid);
	return 1;
}
dcmd_b(playerid,params[]) {
   #pragma unused params
   AllPlayerMenu("buygan",playerid);
   return 1;
}

dcmd_k(playerid,params[]) {
	#pragma unused params
	SetPlayerHealth(playerid,0);
	return 1;
}
dcmd_kill(playerid,params[]) {
	dcmd_k(playerid,params);
	return 1;
}

dcmd_send(playerid,params[]) {
	#pragma unused params
	WriteEcho("ОШИБКА: Данная команда не совместима с этой версией мода.",playerid,ErrorMsgColor);
	WriteEcho("СПРАВКА: Для перевода денег дрегому игроку нажмите клавишу \"Tab\" и кликнете по его(её) нику в списке игроков",playerid,HelpMsgColor);
	WriteEcho("В появившемся списке выберете \"Передать деньги\"",playerid,HelpMsgColor);
	WriteEcho("ИНФО: Обязательно посетите сайт и форум сервера: www.jru-team.ru",playerid);
	return 1;
}

dcmd_report(playerid,params[]) {
	new tmp[MAX_STRING],idx;
	tmp = strtok(params,idx);
	if (!strlen(tmp)) {
		WriteEcho("Используй: /report <playerid> <текст>",playerid,HelpMsgColor);
		return 1;
	}
	new targetid = strval(tmp);
	if (targetid == playerid) {
		WriteEcho("Нельзя жаловатся на себя",playerid,ErrorMsgColor);
		return 1;
	}
	new str[MAX_STRING];
	if (!IsPlayerConnected(targetid)) {
		format(str,sizeof(str),"Нельзя жаловатся на несуществующих игроков (%d)",targetid);
		WriteEcho(str,playerid,ErrorMsgColor);
		return 1;
	}
	if (IsPlayerAdmin(targetid) || PlayerInfo[targetid][Admin] >= PlayerInfo[playerid][Admin]) {
		format(str,sizeof(str),"You cannot report on admins (%s (id: %d))",PlayerInfo[targetid][Name],targetid);
		WriteEcho(str,playerid,ErrorMsgColor);
		return 1;
	}
	new tmp2[MAX_STRING];
	strmid(tmp2,params,strlen(tmp)+1,strlen(params));
	if (!strlen(tmp2)) {
		WriteEcho("Используй: /report <playerid> <текст>",playerid,HelpMsgColor);
		return 1;
	}
	format(str,sizeof(str),"Игрок %s (id: %d) жалуется на %s (id: %d): %s",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,tmp2);
	WriteToLog(str);
	#if defined AdminsLog
		WriteToLog(str,AdminsLog);
	#endif
	for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
    WriteEcho("Твоя жалоба направлена админам",playerid);
	return 1;
}

new bool:CountDown;
new bool:InCountDown[MAX_PLAYERS];
public CountDown0() {
    for (new i=0;i<MAX_PLAYERS;i++) {
        if (InCountDown[i]) {
            GameTextForPlayer(i,"~r~~h~GO!",1000,3);
			//TogglePlayerControllable(i,1);
        }
    }
    CountDown = false;
}
public CountDown1() for (new i=0;i<MAX_PLAYERS;i++) if (InCountDown[i]) GameTextForPlayer(i,"~r~~h~1",1000,3);
public CountDown2() for (new i=0;i<MAX_PLAYERS;i++) if (InCountDown[i]) GameTextForPlayer(i,"~g~~h~2",1000,3);
public CountDown3() for (new i=0;i<MAX_PLAYERS;i++) if (InCountDown[i]) GameTextForPlayer(i,"~g~~h~3",1000,3);
public CountDown4() for (new i=0;i<MAX_PLAYERS;i++) if (InCountDown[i]) GameTextForPlayer(i,"~b~~h~4",1000,3);
public CountDown5() for (new i=0;i<MAX_PLAYERS;i++) if (InCountDown[i]) GameTextForPlayer(i,"~b~~h~5",1000,3);
dcmd_countdown(playerid,params[]) {
	#pragma unused params
	if (GetPlayerState(playerid) == PLAYER_STATE_NONE || GetPlayerState(playerid) == PLAYER_STATE_WASTED) {
	    WriteEcho("Нужно заспавнится чтобы запустить отчет",playerid,ErrorMsgColor);
		return 1;
	}
	if (CountDown) {
	    WriteEcho("Обратный отчет запущен",playerid,ErrorMsgColor);
		return 1;
	}
	CountDown = true;
	new Float:x,Float:y,Float:z;
	GetPlayerPos(playerid,x,y,z);
	for (new i=0;i<MAX_PLAYERS;i++) {
		if (IsPlayerInArea(i,x-20,x+20,y-20,x+20,z-5,z+5) && GetPlayerState(i) != PLAYER_STATE_NONE && GetPlayerState(i) != PLAYER_STATE_WASTED) {
			InCountDown[i] = true;
			//TogglePlayerControllable(i,0);
			GameTextForPlayer(i,"~w~~h~READY!",1000,3);
		}
		else InCountDown[i] = false;
	}
	SetTimer("CountDown0",6000,0);
	SetTimer("CountDown1",5000,0);
	SetTimer("CountDown2",4000,0);
	SetTimer("CountDown3",3000,0);
	SetTimer("CountDown4",2000,0);
	SetTimer("CountDown5",1000,0);
	return 1;
}
#define Locations 28
enum LocationInfos {
	LocationName[24],
	Float:LocationX,
	Float:LocationY,
	Float:LocationZ
}
new LocationInfo[Locations][LocationInfos] = {
	{"LS Грув Стрит",2492.9375,-1670.4402,13.3359},
	{"LS Аэрапорт",1925.1957,-2426.8733,13.5391},
	{"LS Небоскреб",1556.2386,-1357.8395,329.4544},
	{"LS Маяк",154.0820,-1938.4050,3.7734},
	{"SF Стройка",-2026.0696,175.2042,28.8359},
	{"SF Аэрапорт",-1281.1655,-166.1917,14.1484},
	{"SF Башня",-1753.8291,885.4835,295.8750},
	{"SF Золотой мост",-2678.8230,1595.1827,217.2739},
	{"SF Тюненг",-2700.8403,217.0844,4.1797},
	{"LV Казино Драконов",2030.2551,1007.9247,10.8203},
	{"LV Аэропорт",1525.6610,1594.5865,10.8203},
	{"LV Небоскреб",2057.1145,2435.5623,165.6172},
 	{"LS Завод",2508.8118,2770.5029,10.8203},
	{"LV ЖД Станция 1",1433.3354,2616.8560,11.3926},
	{"LV Авто-сервис",1958.2587,2150.9619,10.8203},
	{"LV Китай город",2611.5186,1823.9960,10.8203},
	{"LV ЖД Станция 2",2858.0425,1290.9613,11.3906},
	{"LV Тюненг",2385.7109,1026.4231,10.8203},
	{"LV Лодочная станция",2358.8674,572.2090,7.7813},
	{"LV Дом",1294.2922,2529.1426,10.6719},
	{"LV Дальнобойщики",1114.3236,1878.6791,10.8203},
	{"LV Карьер",664.6312,894.7714,-40.3984},
	{"Гора Чиллиэд",-2321.2866,-1637.9414,483.7031},
	{"Заброшенный аэро",324.9738,2520.6030,16.6942},
	{"Военная база",213.6413,1904.4032,17.6406},
	{"Дрифт Зона",-363.4121,1499.6205,82.4428},
	{"Party Home",-701.7267,955.2220,12.3649},
	{"МегаТрамплин",-710.1226,2327.2705,127.2733}
};
dcmd_gamemodeexit(playerid,params[]) {
	#pragma unused params
	new str[MAX_STRING];
	format(str,sizeof(str),"%s (id %d) перезапустил мод",PlayerInfo[playerid][Name],playerid);
	WriteToLog(str);
	#if defined AdminsLog
	   	WriteToLog(str,AdminsLog);
	#endif
	for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	WriteEcho("Перезапуск игрового мода...",playerid);
	GameModeExit();
	return 1;
}
dcmd_gmx(playerid,params[]){
   #pragma unused params
   dcmd_gamemodeexit(playerid,params);
   return 1;
}
dcmd_say(playerid,params[]) {
    new tmp[MAX_STRING],idx;
	tmp = strtok(params,idx);
	if(PlayerInfo[playerid][Jailed]){ WriteEcho("Ты не можешь использовать эту команду находясь в тюрьме.", playerid, ErrorMsgColor); return 0;}
	if(PlayerInfo[playerid][Mute]) WriteEcho("Тебе запрещено и это действие.", playerid, ErrorMsgColor);
	if (!strlen(tmp)) {
		WriteEcho("Используй: /say <текст>",playerid,HelpMsgColor);
		return 1;
	}
	new str[MAX_STRING];
	format(str,sizeof(str),"%s (id %d) say: %s",PlayerInfo[playerid][Name],playerid,params);
	WriteToLog(str);
	#if defined AdminsLog
	   	WriteToLog(str,AdminsLog);
	#endif
	format(str,sizeof(str),"* Админ %s: %s",PlayerInfo[playerid][Name],params);
	SendClientMessageToAll(AdminSayColor,str);
	#if defined IrcOnOff
	format(str,sizeof(str),"10* Админ %s: %s",PlayerInfo[playerid][Name],params);
	IRC_GroupSay(gGroupID, IRC_CHANNEL,str);
	#endif
	return 1;
}
dcmd_flip(playerid,params[]) {
	#pragma unused params
	if(IsPlayerInAnyVehicle(playerid)) {
	new Float:X,Float:Y,Float:Z,Float:Angle; GetVehiclePos(GetPlayerVehicleID(playerid),X,Y,Z); GetVehicleZAngle(GetPlayerVehicleID(playerid),Angle);
	SetVehiclePos(GetPlayerVehicleID(playerid),X,Y,Z+2); SetVehicleZAngle(GetPlayerVehicleID(playerid),Angle);
	}
	else WriteEcho("Ошибка: Ты должен быть в машине.",playerid,ErrorMsgColor); return 1;
}
dcmd_slap(playerid,params[]) {
    new tmp[MAX_STRING],idx;
	tmp = strtok(params,idx);
	if(PlayerInfo[playerid][Jailed]) WriteEcho("Ты не можешь использовать эту команду находясь в тюрьме.", playerid, ErrorMsgColor);
    if (!strlen(tmp)) {
		WriteEcho("Используй: /slap <playerid>",playerid,HelpMsgColor);
		return 1;
	}
	new str[MAX_STRING],targetid = strval(tmp);
	if(PlayerInfo[playerid][Admin]<PlayerInfo[targetid][Admin]){ WriteEcho("Припух? Мал еще админа слапать.", playerid, ErrorMsgColor); new Float:Health; GetPlayerHealth(playerid,Health); SetPlayerHealth(playerid,Health-50); return 0;}
	if(IsPlayerConnected(targetid) && targetid != INVALID_PLAYER_ID && targetid != playerid && PlayerInfo[playerid][Admin]>PlayerInfo[targetid][Admin]) {
	format(str,256,"Админстратор \"%s (id: %d)\" ударил \"%s (id: %d)\".",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	WriteEcho(str,ErrorMsgColor);
	new Float:Health; GetPlayerHealth(targetid,Health); return SetPlayerHealth(targetid,Health-20);
	}
	else WriteEcho("Ошибка: Вы не можете бить себя и несуществующих игроков.",playerid,ErrorMsgColor); return 1;
}
dcmd_carcolor(playerid,params[]) {
	    new tmp[256],tmp2[256],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
	    if(!strlen(tmp)||!(strval(tmp) >= 0 && strval(tmp) <= 126)){
		WriteEcho("Используй: \"/carcolor <цвет 1> (<цвет 2>).",playerid,HelpMsgColor);
		return 1;
		}
		if(!IsPlayerInAnyVehicle(playerid)){
		WriteEcho("Ты должен быть в машине.",playerid,ErrorMsgColor);
		return 1;
		}
		if(!strlen(tmp2)) tmp2 = tmp;
		new str[256],name[24]; GetPlayerName(playerid,name,24);
		format(str,sizeof(str),"Вы поменяли цвет своей машины: [Цвет 1: %d || Цвет 2: %d]",strval(tmp),strval(tmp2));
        WriteEcho(str,playerid);
		return ChangeVehicleColor(GetPlayerVehicleID(playerid),strval(tmp),strval(tmp2));
}
dcmd_vr(playerid,params[]) {
	#pragma unused params
    if(!IsPlayerInAnyVehicle(playerid)){
	WriteEcho("Чтобы починить машину, ты должен быть в ней.",playerid,ErrorMsgColor);
	return 1;
	}
	RepairVehicle(GetPlayerVehicleID(playerid));
	WriteEcho("Вы успешло починили свою машину!",playerid);
	return 1;
}

dcmd_exp(playerid,params[]) {
	    if(!strlen(params)){
		   WriteEcho("Ошибка: \"/EXPLODE <НИК или ID>\".",playerid,HelpMsgColor);
		   return 1;
        }
   		new id; id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
		    new string[256],name[24],ActionName[24],Float:X,Float:Y,Float:Z; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(!IsPlayerInAnyVehicle(id)) GetPlayerPos(id,X,Y,Z); else GetVehiclePos(GetPlayerVehicleID(id),X,Y,Z); for(new i = 1; i <= 5; i++) CreateExplosion(X,Y,Z,10,0);
		    if(id != playerid) {
				format(string,256,"Вы были взорваны администратором \"%s\".",name); WriteEcho(string,id,ErrorMsgColor);
		    	format(string,256,"Вы взорвали \"%s\".",ActionName); WriteEcho(string,playerid,ErrorMsgColor); return 1;
			} else WriteEcho("Вы взорвали себя.",playerid,ErrorMsgColor); return 1;
		} else return 1;
}
dcmd_del(playerid,params[]){
   #pragma unused params
   for(new i=0;i<MaxChatLinies;i++){
	  SendClientMessageToAll(0xFFFFFF,"");
   }
   new str[256];
   format(str,sizeof(str),"%s %s (id: %d) очистил чат.",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid);
   WriteEcho(str,INVALID_PLAYER_ID,SystemMsgColor);
   return 1;
}

//==================[AFK]==============>
dcmd_afk(playerid,params[]){
    #pragma unused params
    new str[MAX_STRING];
    if(PlayerInfo[playerid][Jailed]){
	   WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	   return 0;
    }
    if(!PlayerInfo[playerid][AFK]){
	   PlayerInfo[playerid][AFK] = 1;
       format(str, sizeof(str), " *** %s отошел(afk).",PlayerInfo[playerid][Name]);
	   SendClientMessageToAll(COLOR_LIGHTBLUE, str);
	   #if defined IrcOnOff
	   format(str,sizeof(str),"11 *** %s отошел(afk).",PlayerInfo[playerid][Name]);
	   IRC_GroupSay(gGroupID, IRC_CHANNEL,str);
	   #endif
	   SendClientMessage(playerid, SystemMsgColor, " * Что-бы вернутся, используйте команду /back или клавишу \"Enter\"");
	   format(str,sizeof(str),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~%s ~w~is afk.",PlayerInfo[playerid][Name]);
	   GameTextForAll(str,3000,3);
	   PlayerInfo[playerid][NikColor] = GetPlayerColor(playerid);
	   SetPlayerColor(playerid,COLOR_LIGHTBLUE);
	   PlayerInfo[playerid][AFKMsg] = Create3DTextLabel("-={AFK}=-",COLOR_LIGHTBLUE,30.0,40.0,50.0,40.0,0);
       Attach3DTextLabelToPlayer(PlayerInfo[playerid][AFKMsg], playerid, 0.0, 0.0, 0.3);
	   TogglePlayerControllable(playerid, 0);
	}
	else {
	   WriteEcho("Вы уже находитесь в AFK.",playerid,ErrorMsgColor);
	   return 1;
	}
	return 1;
}

dcmd_back(playerid,params[]){
    #pragma unused params
    new str[MAX_STRING];
    if(PlayerInfo[playerid][Jailed]){
	   WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	   return 0;
    }
    if(PlayerInfo[playerid][AFK]){
	   PlayerInfo[playerid][AFK] = 0;
       Delete3DTextLabel(PlayerInfo[playerid][AFKMsg]);
       SetPlayerColor(playerid,PlayerInfo[playerid][NikColor]);
       format(str, sizeof(str), " *** %s вернулся.",PlayerInfo[playerid][Name]);
	   SendClientMessageToAll(COLOR_LIGHTBLUE, str);
	   #if defined IrcOnOff
	   format(str,sizeof(str),"11 *** %s вернулся.%s",PlayerInfo[playerid][Name]);
	   IRC_GroupSay(gGroupID, IRC_CHANNEL,str);
	   #endif
	   format(str,sizeof(str),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~%s ~w~is afk.",PlayerInfo[playerid][Name]);
	   GameTextForAll(str,3000,3);
	   TogglePlayerControllable(playerid, 1);
	}
	else {
	   WriteEcho("Вы не находитесь в AFK.",playerid,ErrorMsgColor);
	   return 1;
	}
	return 1;
}

dcmd_me(playerid,params[]){
   #pragma unused params
   AllPlayerMenu("usermenu",playerid);
   return 1;
}
dcmd_amenu(playerid,params[]){
   #pragma unused params
   AllPlayerMenu("adminmenu",playerid);
   return 1;
}
dcmd_pm(playerid,params[]){
   #pragma unused params
   WriteEcho("ОШИБКА: Данная команда не совместима с этой версией мода.",playerid,ErrorMsgColor);
   WriteEcho("СПРАВКА: Чтобы отправить ПМ нажмите на клавишу \"Tab\" и путем клика по нику игрока вызовите \"Меню действия\"",playerid,HelpMsgColor);
   WriteEcho("В этом меню выберете пункт \"Написать ПМ\" и следуйте дальнейшим инструкциям.",playerid,HelpMsgColor);
   return 1;
}
dcmd_piss(playerid,params[]){
   #pragma unused params
   ApplyAnimation(playerid, "PAULNMAC", "Piss_in", 3.0, 0, 0, 0, 0, 0);
   SendClientMessage(playerid,HelpMsgColor,"Хватит ссать!");
   return 1;
}
dcmd_p(playerid,params[]){
   dcmd_piss(playerid,params);
   return 1;
}
#if defined HousesOnOff
dcmd_ahouses(playerid,params[]) {
    #pragma unused params
    new listitems[] = "1\tСохранить значок входа\n2\tСх. зн. выхода (! нет)\n3\tСх. место спавна\n4\tПерезагрузить дома\n4\tУст. владельца\n5\tВыбрать интерьер";
	    ShowPlayerDialog(playerid,550,DIALOG_STYLE_LIST,"АССД (by [JRU]kroks):",listitems,"Да","Да нах");

	return 1;
}
#endif
//дуэли by kroks_rus
dcmd_duel(playerid,params[]){
   #pragma unused params
   if (gduel==0){
	  ShowPlayerDialog(playerid,2005,DIALOG_STYLE_MSGBOX,"Дуэль","Дуэль не создана.\nСоздать?","OK","Cancel");
   }
   if (gduel==1){
      if (playerid==gplay1){
	     ShowPlayerDialog(playerid,2002,DIALOG_STYLE_MSGBOX,"Дуэль","Вы создали дуэль.\nОтменить?","OK","Cancel");
      }
	  else {
	     ShowPlayerDialog(playerid,2003,DIALOG_STYLE_MSGBOX,"Дуэль","Присоедениться к дуэли?","OK","Cancel");
	  }
   }
   if (gduel==2){
      ShowPlayerDialog(playerid,2004,DIALOG_STYLE_MSGBOX,"Ошибка","Дуэль проходит в данный момент.","OK","Cancel");
   }
   return 1;
}
dcmd_aduel(playerid,params[]){
   #pragma unused params
   if(IsPlayerAdmin(playerid) || PlayerInfo[playerid][Admin]>5){
      ShowPlayerDialog(playerid,2009,DIALOG_STYLE_MSGBOX,"Админ","Отменить дуэль?","OK","Cancel");
   }
   return 1;
}
//^дуэли by kroks_rus

public OnPlayerCommandText(playerid,cmdtext[]) {
	if (!IsPlayerConnected(playerid)) return 0;
	if (strlen(cmdtext) > 64) {
		KickPlayer(playerid,"Слишком длинная команда");
		return 0;
	}
	#if defined FloodInterval && defined FloodLines
	    if (!IsPlayerAdmin(playerid) && PlayerInfo[playerid][Admin] < AdminLevelToIgnorePunishment) {
	    	PlayerInfo[playerid][Messages]++;
	    	if (PlayerInfo[playerid][Messages] > FloodLines) {
	    	    PlayerInfo[playerid][Messages] = 0;
				KickPlayer(playerid,"Stop flooding");
	            return 0;
	    	}
		}
	#endif
	FixChars(cmdtext);
	#if defined CommandsLog
	    new str[MAX_STRING];
		format(str,sizeof(str),"%s (id: %d) typed command %s",PlayerInfo[playerid][Name],playerid,cmdtext);
		WriteToLog(str,CommandsLog);
		delete str;
	#endif
	dcmd(help,4,cmdtext);//0
	dcmd(h,1,cmdtext);
	dcmd(commands,8,cmdtext);//1
	dcmd(c,1,cmdtext);
	dcmd(register,8,cmdtext);
	dcmd(login,5,cmdtext);
	dcmd(l,1,cmdtext);
	dcmd(stats,5,cmdtext);
	dcmd(s,1,cmdtext);
	dcmd(query,5,cmdtext);
	dcmd(ignore,6,cmdtext);
	if (dini_Exists(PlayerFile(PlayerInfo[playerid][Name])) && !PlayerInfo[playerid][Logged]) {
		WriteEcho("ОШИБКА: Чтобы воспользоваться этой вазможностью необходимо залогиниться.",playerid,ErrorMsgColor);
		WriteEcho("",playerid,-1,2,1,"Вход","Введите свой пароль","Войти","Отмена");
		return 1;
	}
	dcmd(pm,2,cmdtext);
	dcmd(changepassword,14,cmdtext);
	dcmd(weaponlist,10,cmdtext);
	dcmd(w,1,cmdtext);
	dcmd(buy,3,cmdtext);
	dcmd(b,1,cmdtext);
	dcmd(k,1,cmdtext);
	dcmd(kill,4,cmdtext);
	dcmd(send,4,cmdtext);
	dcmd(report,6,cmdtext);
	dcmd(countdown,9,cmdtext);
	dcmd(afk,3,cmdtext);
	dcmd(back,4,cmdtext);
	dcmd(me,2,cmdtext);
	dcmd(piss,4,cmdtext);
	dcmd(p,1,cmdtext);
	dcmd(duel,4,cmdtext);
	if (PlayerInfo[playerid][Admin] > 0) {
        dcmd(amenu,5,cmdtext);
		/*dcmd(ahelp,5,cmdtext);
		dcmd(acolor,6,cmdtext);
		dcmd(announce,8,cmdtext);
		dcmd(mute,4,cmdtext);
		dcmd(unmute,6,cmdtext);
		dcmd(jail,4,cmdtext);
	    dcmd(unjail,6,cmdtext);*/
	    dcmd(vr,2,cmdtext);
	    dcmd(carcolor,8,cmdtext);
	    dcmd(del,3,cmdtext);
	}
	if (PlayerInfo[playerid][Admin] > 1) {
		//dcmd(kick,4,cmdtext);
		//dcmd(ban,3,cmdtext);
		dcmd(say,3,cmdtext);
	    dcmd(flip,4,cmdtext);
	}
	if (PlayerInfo[playerid][Admin] > 2) {
		//dcmd(outcar,6,cmdtext);
	}
	if (PlayerInfo[playerid][Admin] > 3) {
		/*dcmd(locations,9,cmdtext);
		dcmd(teleport,8,cmdtext);
		dcmd(tocar,5,cmdtext);*/
	}
	if (PlayerInfo[playerid][Admin] > 4) {
		dcmd(slap,4,cmdtext);
	}
	if (PlayerInfo[playerid][Admin] > 5) {
		dcmd(aduel,5,cmdtext);
	}
	if (PlayerInfo[playerid][Admin] > 6) {
		/*dcmd(hearall,7,cmdtext);
		dcmd(settime,7,cmdtext);*/
	}
	if (PlayerInfo[playerid][Admin] > 7) {
        #if defined HousesOnOff
           dcmd(ahouses,6,cmdtext);
        #endif
	}
	if (PlayerInfo[playerid][Admin] > 8) {
		//dcmd(globalsave,10,cmdtext);
		dcmd(gamemodeexit,12,cmdtext);
		dcmd(gmx,3,cmdtext);
		dcmd(exp,3,cmdtext);
	}
	new str[MAX_STRING],cmd[MAX_STRING],idx;
	cmd = strtok(cmdtext,idx);
	format(str,sizeof(str),"Команды (%s) не существует.",cmd);
	WriteEcho(str,playerid,ErrorMsgColor);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
   new str[MAX_STRING];
   if(dialogid == 0) {
      if(response) {
	     new tmp[MAX_STRING],idx;
	     tmp = strtok(inputtext,idx);
	     if (!strlen(tmp)) {
		    WriteEcho("",playerid,-1,2,0,"Регистрация.Ошибка.","Вы не ввели пароль.\nВведите желаемый пароль","Рег-ция","Отмена");
		    return 1;
	     }
	     if (strlen(tmp) < 5) {
		    WriteEcho("Пароль должен состоять минимум из 5 символов",playerid,ErrorMsgColor);
		    WriteEcho("",playerid,-1,2,0,"Регистрация.Ошибка.","Слишком короткий пароль.\nВведите желаемый пароль","Рег-ция","Отмена");
		    return 1;
	     }
		 else{
	     dini_Create(PlayerFile(PlayerInfo[playerid][Name]));
	     PlayerInfo[playerid][Password] = num_hash(tmp);
	     PlayerInfo[playerid][Logged] = true;
	     SavePlayer(playerid);
	     PlayerInfo[playerid][SafeDeath] = true;
	     PlayerInfo[playerid][LogginType] = 1;
	     SetSpawnInfo(playerid,0,0,0,0,5,0,0,0,0,0,0,0);
	     SpawnPlayer(playerid);
	     SetPlayerCameraPos(playerid,1481.4418,-1795.4611,156.7533);
	     SetPlayerCameraLookAt(playerid,1481.4418,-1790.4611,156.7533);
	     SetPlayerHealth(playerid,0);
	     ForceClassSelection(playerid);
	     SetPlayerColor(playerid,DefaultPlayerColors[playerid]-0xFF);
	     new name[40],newName[40];
	     GetPlayerName(playerid,name,40);
	     format(newName,sizeof(newName),"%s_(Registr)",name);
	     SetPlayerName(playerid,newName);
	     SendDeathMessage(INVALID_PLAYER_ID,playerid,201);
	     SetPlayerName(playerid,name);
	     format(str,sizeof(str),"%s (id: %d) registered an account",PlayerInfo[playerid][Name],playerid);
	     WriteToLog(str);
	     format(str,sizeof(str),"* Вы зарегистрировали свой ник \"%s\"! И автоматически залогинены.",PlayerInfo[playerid][Name],tmp);
         SendClientMessage(playerid,0xFFFF00AA,str);SendClientMessage(playerid,0xFFFF00AA,"ПОДСКАЗКА: Функцию автоматического входа можно отключить в настройках профиля.");}
	     return 1;
      }
	  else {
         WriteEcho("",playerid,-1,3,3,"Отказ от регистрации.","Вы уверенны, что хотите\nотключиться от сервера?","Да","Нет");
      }
      return 1;
   }
   if(dialogid == 1) {
      if(response) {
         if (!dini_Exists(PlayerFile(PlayerInfo[playerid][Name]))) {
		    format(str,sizeof(str),"Этот ник (%s) не зарегестрирован. Зарегестрируйся с помощь команды /register",PlayerInfo[playerid][Name]);
		    WriteEcho(str,playerid,ErrorMsgColor);
		    return 1;
	     }
	     new tmp[MAX_STRING],idx,plrIP[16];
	     tmp = strtok(inputtext,idx);
	     if (!strlen(tmp)) {
		    WriteEcho("",playerid,-1,2,1,"Вход. Ошибка","Вы не указали пароль.\nВведите свой пароль","Войти","Отмена");
		    return 1;
	     }
	     if (PlayerInfo[playerid][Password] != num_hash(tmp)) {
		    PlayerInfo[playerid][WrongPasswords]++;
		    if (PlayerInfo[playerid][WrongPasswords] > 5) {
			   KickPlayer(playerid,"Не верный пароль");
			   return 1;
		    }
		    format(str,sizeof(str),"%s (id: %d) typed wrong password",PlayerInfo[playerid][Name],playerid);
		    WriteToLog(str);
		    for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
		    format(str,sizeof(str),"Вы ввели не верный пароль (%s)\nВведите свой пароль",tmp,PlayerInfo[playerid][WrongPasswords]);
		    WriteEcho("",playerid,-1,2,1,"Вход",str,"Войти","Отмена");
		    return 1;
	     }
	     PlayerInfo[playerid][Logged] = true;
	     GetPlayerIp(playerid, plrIP, sizeof(plrIP));
	     PlayerInfo[playerid][PlayerIP]=plrIP;
	     format(str,sizeof(str),"%s (id: %d) logged in",PlayerInfo[playerid][Name],playerid);
	     WriteToLog(str);
	     WriteEcho("Ты вошел(а).",playerid);
	     PlayerInfo[playerid][SafeDeath] = true;
	     SetSpawnInfo(playerid,0,0,0,0,5,0,0,0,0,0,0,0);
	     SpawnPlayer(playerid);
	     SetPlayerCameraPos(playerid,1481.4418,-1795.4611,156.7533);
	     SetPlayerCameraLookAt(playerid,1481.4418,-1790.4611,156.7533);
	     SetPlayerHealth(playerid,0);
	     SetPlayerColor(playerid,DefaultPlayerColors[playerid]-0xFF);
	     new name[40],newName[40];
	     GetPlayerName(playerid,name,40);
	     format(newName,sizeof(newName),"%s_(Login)",name);
	     SetPlayerName(playerid,newName);
	     SendDeathMessage(INVALID_PLAYER_ID,playerid,201);
	     SetPlayerName(playerid,name);
	     return 1;
      }
	  else {
         WriteEcho("",playerid,-1,3,31,"Выход.","Вы уверенны, что хотите\nотключиться от сервера?","Да","Нет");
      }
      return 1;
   }
   if(dialogid == 3) {
      if(response) {
		 WriteEcho("На нашем сервере нельзя играть без регистрации.",playerid,KickMsgColor);
         Kick(playerid);
      }
	  else {
         WriteEcho("",playerid,-1,2,3,"Регистрация","Введите желаемый пароль.","Рег-ция","Отмена");
		 //WriteEcho("",playerid,-1,2,1,"Вход","Введите свой пароль","Войти","Отмена");
      }
      return 1;
   }
   if(dialogid == 31) {
      if(response) {
		 WriteEcho("На нашем сервере нельзя играть без регистрации.",playerid,KickMsgColor);
         Kick(playerid);
      }
	  else {
		 WriteEcho("",playerid,-1,2,1,"Вход","Введите свой пароль","Войти","Отмена");
      }
      return 1;
   }
   if(dialogid == 4) {
	  new idx;
      if(response) {
	     if(PlayerInfo[playerid][Admin]){
            idx=1;
			if(listitem == 0) {
			   AllPlayerMenu("adminmenu",playerid);
			   return 1;
			}
		 }
		 if(listitem == 0+idx) {
            if(PlayerInfo[playerid][Jailed]){
	           WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	           return 0;
            }
            for(new i=0;i<Weapons;i++){
			   format(str,sizeof(str),"%s\n%s ($%d)",str,GetWeaponNameRu(WeaponInfo[i][WeaponID]),WeaponInfo[i][WeaponCost]);
			}
            WriteEcho("",playerid,-1,4,7,"Купить оружие",str,"Купить","Отмена");
		    return 1;
         }
         if(listitem == 1+idx) {
            if(PlayerInfo[playerid][Jailed]){
	           WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	           return 0;
            }
            format(str,sizeof(str),"*** %s (id: %d) приветствует ВСЕХ! ***",PlayerInfo[playerid][Name],playerid);
	        SendClientMessageToAll(0x00CC00AA,str);
		 }
         if(listitem == 2+idx) {
            if(PlayerInfo[playerid][Jailed]){
	           WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	           return 0;
            }
            format(str,sizeof(str),"*** %s (id: %d) пращаеться со всеми и уходит. ***",PlayerInfo[playerid][Name],playerid);
	        SendClientMessageToAll(0x990000AA,str);
		 }
         if(listitem == 3+idx) {
            if(PlayerInfo[playerid][Jailed]){
	           WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	           return 0;
            }
            format(str,sizeof(str),"Ваша статистика (%s):",PlayerInfo[playerid][Name]);
		    WriteEcho(str,playerid);
		    format(str,sizeof(str),"Уровень доступа: \"%s\"",PlayerAdminLevel(PlayerInfo[playerid][Admin]));
		    WriteEcho(str,playerid,HelpMsgColor);
		    format(str,sizeof(str),"Игровой уровень: 0",PlayerInfo[playerid][Level]);
		    WriteEcho(str,playerid,HelpMsgColor);
		    format(str,sizeof(str),"Денег на руках: $%d",GetPlayerMoney(playerid));
		    WriteEcho(str,playerid,HelpMsgColor);
		    format(str,sizeof(str),"Денег в банке: $%d",PlayerInfo[playerid][Bank]);
		    WriteEcho(str,playerid,HelpMsgColor);
		    format(str,sizeof(str),"Недвижимость: %d",PlayerInfo[playerid][House]);
		    WriteEcho(str,playerid,HelpMsgColor);
		    format(str,sizeof(str),"Транспорт: %s",PlayerInfo[playerid][Vehicle]);
		    WriteEcho(str,playerid,HelpMsgColor);
		    format(str,sizeof(str),"Убийств: %d",PlayerInfo[playerid][Kills]);
		    WriteEcho(str,playerid,HelpMsgColor);
		    format(str,sizeof(str),"Максимум убийств за жизнь: %d",PlayerInfo[playerid][MaxKillsForLife]);
		    WriteEcho(str,playerid,HelpMsgColor);
		    format(str,sizeof(str),"Смертей: %d",PlayerInfo[playerid][Deaths]);
		    WriteEcho(str,playerid,HelpMsgColor);
		    format(str,sizeof(str),"Самоубийств: %d",PlayerInfo[playerid][Suicides]);
		    WriteEcho(str,playerid,HelpMsgColor);
		    if (PlayerInfo[playerid][Deaths] > 0) {
		       new Float:ratio = floatdiv(PlayerInfo[playerid][Kills],PlayerInfo[playerid][Deaths]);
			   format(str,sizeof(str),"Соотношение убийство/смерть: %f",ratio);
			   WriteEcho(str,playerid,HelpMsgColor);
		    }
		 }
         if(listitem == 4+idx) {//дуэль
            if(PlayerInfo[playerid][Jailed]){
	           WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	           return 0;
            }
            if (gduel==0) WriteEcho("",playerid,-1,3,2005,"Вызов на дуэль","Вы хотите объявить дуэль?","Да","Отмена");
            if (gduel==1){
	           if (playerid==gplay1) WriteEcho("",playerid,-1,3,2002,"Дуэль","Вы создали дуэль.\nОтменить?","OK","Cancel");
			   else WriteEcho("",playerid,-1,3,2003,"Дуэль","Присоедениться к дуэли?","OK","Cancel");
            }
	        if (gduel==2) WriteEcho("",playerid,-1,3,2004,"Ошибка","Дуэль проходит в данный момент.","OK","Cancel");
		 }
         if(listitem == 5+idx) {//помощь
            WriteEcho("SimpleDM by by ProRaiL. Update by JRU Team",playerid);
            SendClientMessage(playerid,SystemMsgColor,"[JRU]S_S (icq:2622124) & [JRU]kroks_rus (icq:466237940). Tested [JRU]zoltan");
			#if defined Teams
		       if (PlayerInfo[playerid][Team] > -1) WriteEcho("Ты можешь писать сообщения игрокам из cвоей команды, используя \"*\" перед текстом",playerid,HelpMsgColor);
	        #endif
	        WriteEcho("В моде существует несколько видов меню: Меню игрока и Меню действий над другим игроком.",playerid,HelpMsgColor);
	        WriteEcho("Существует 3 способа вызова Меню игрока (т.е. своего меню):",playerid,HelpMsgColor);
	        WriteEcho("первый заключается в использовании команды /me которая выведет ваше меню;",playerid,HelpMsgColor);
	        WriteEcho("второй способ - это вывод того же меню при нажатии клавиш  \"Alt\" и \"Num 1\";",playerid,HelpMsgColor);
	        WriteEcho("третий способ - нужно нажать клавишу \"Tab\" и в появившемся списке кликнуть мышью",playerid,HelpMsgColor);
		    SendClientMessage(playerid,HelpMsgColor,"по своему нику, после чего вам будет выведено Меню игрока.");
		    WriteEcho("Для совершения, каких либо действий с другим игроком необходимо вызвать Меню действий.",playerid,HelpMsgColor);
		    SendClientMessage(playerid,HelpMsgColor,"Это меню вызывается нажатием на клавише \"Tab\" и клику по нику игрока, с которым вы бы хотели совершить");
		    SendClientMessage(playerid,HelpMsgColor,"какое либо действие (Например: поприветствовать, попрощаться с игроком, передать денег, пожаловаться, и т.д.)");
	        WriteEcho("Пакупка оружия /b",playerid,HelpMsgColor);
	        WriteEcho("Обязательно прочитайте правила игры на этом сервере. В своем меню или воспользуйтесь командой /rules",playerid,ErrorMsgColor);
	        WriteEcho("Список доступных команд /help, /l[ogin], /rules, /me",playerid,HelpMsgColor);
		 }
		 if(listitem == 6+idx) {//привила
		 	WriteEcho("<----------[Правила игры на нашем сервере]--------->",playerid,HelpMsgColor);
		    WriteEcho("1 Игровой процесс.",playerid,HelpMsgColor);
   	        WriteEcho("1.1 Запрещено использовать читы, трейнеры, моды или любые другие способы получения нечестного превосходства над противником. (бан)",playerid,HelpMsgColor);
            WriteEcho("1.2 Запрещено убивать игроков на спавне (на месте, где они появляются в игре). (тюрьма)",playerid,HelpMsgColor);
            WriteEcho("1.3 Запрещено убивать соперника путем наезда и остановки непосредственно на нем. (тюрьма(5мин)/кик)",playerid,HelpMsgColor);
            WriteEcho("1.4 Запрещено убийство из авто водителем. Стрелять могут только пассажиры!  (тюрьма(5мин)/кик/бан)",playerid,HelpMsgColor);
            WriteEcho("1.5 Запрещено использовать багги сервера и т.п. (бан)",playerid,HelpMsgColor);
            WriteEcho("2 Процесс общения (в общий чат и PM).",playerid,HelpMsgColor);
            WriteEcho("2.1 Запрещено материться. (кляп)",playerid,HelpMsgColor);
            WriteEcho("2.2 Запрещено оскорблять игроков. (кляп/тюрьма)",playerid,HelpMsgColor);
            WriteEcho("2.3 Запрещены угрозы игрокам (не относящиеся к игровому процессу). (кляп)",playerid,HelpMsgColor);
            WriteEcho("2.4 Запрещен флуд как в общем чате, так и в приват (PM) игроку (кляп/тюрьма/кик)",playerid,HelpMsgColor);
            WriteEcho("2.5 Запрещена любая реклама сервера, сайта и т.д. в любом ее проявлении. (кик/бан)",playerid,HelpMsgColor);
            WriteEcho("2.6 Запрещено обсуждение читов и подобного софта в общем чате и между игроками в (PM) (кик/бан)",playerid,HelpMsgColor);
            WriteEcho("3 Ники.",playerid,HelpMsgColor);
            WriteEcho("3.1 Запрещено использовать чужие (уже кем-то занятые) ники. (кик/бан)",playerid,HelpMsgColor);
            WriteEcho("3.2 Нежелательно использовать бессмысленные Ники (asdfgh, 124gsv, [[]], admin35 и т.п.).",playerid,HelpMsgColor);
            WriteEcho("3.3 Запрещено использовать Ники, содержащие оскорбительные и/или нецензурные слова. (кик/бан)",playerid,HelpMsgColor);
            WriteEcho("3.4 Нельзя использовать фейк ники (кик/бан)",playerid,HelpMsgColor);
            WriteEcho("3.5 Запрещено использовать тэги чужих кланов, если вы в них не состоите.(кик/бан)",playerid,HelpMsgColor);
            WriteEcho("<---------------------[ВСЁ]------------------------>",playerid,HelpMsgColor);
		 }
		 if(listitem == 7+idx) {//смена пароля
            if(PlayerInfo[playerid][Jailed]){
	           WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	           return 0;
            }
			WriteEcho("",playerid,-1,2,10,"Смена пароля","Введите новы пароль:","Сменить","Отмена");
		 }
		 if(listitem == 8+idx) {//время
            new h,m,s;
            gettime(h,m,s);
            format(str, sizeof(str), "~g~|~w~%d:%d~g~|",h,m);
            GameTextForPlayer(playerid,str,5000,1);
		 }
		 if(listitem == 9+idx) {//термины
            WriteEcho("",playerid,-1,4,9,"Термины","Ping(Пинг)\nNoob(Нуб)\nlol\nLamer(Ламер)\nКапсить\nЧит\nБаг +С","Прочитать","Отмена");
		 }
		 if(listitem == 10+idx) {//Сохранение позиции
            if(PlayerInfo[playerid][Jailed]){
	           WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	           return 0;
            }
            if(GetPlayerMoney(playerid)<5000){
			   WriteEcho("У вас не достаточно денег для сохранения",playerid,ErrorMsgColor);
            }
			GetPlayerPos(playerid,PlayerInfo[playerid][PosX],PlayerInfo[playerid][PosY],PlayerInfo[playerid][PosZ]);
			GiveMoney(playerid,-5000);
            WriteEcho("Позиция сохранена. С вашего счета списанно $5000.",playerid,SystemMsgColor);
			return 1;
		 }
		 if(listitem == 11+idx) {//возврат
            if(PlayerInfo[playerid][Jailed]){
	           WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	           return 0;
            }
            if(GetPlayerMoney(playerid)<500){
			   WriteEcho("У вас не достаточно денег для перемищения",playerid,ErrorMsgColor);
            }
			if(!PlayerInfo[playerid][PosX]){
			   WriteEcho("У вас нет сохраненной позиции",playerid,ErrorMsgColor);
			   return 1;
            }
            else{
			   SetPlayerPos(playerid,PlayerInfo[playerid][PosX],PlayerInfo[playerid][PosY],PlayerInfo[playerid][PosZ]);
			   GiveMoney(playerid,-500);
			   format(str,sizeof(str),"Игрок %s (id: %d) вернулся на пазицию.",PlayerInfo[playerid][Name],playerid);
			   for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
			   WriteEcho("Вы перемещены к месту сохранения. С вашего счета списано $500.",playerid,SystemMsgColor);
			   return 1;
		    }
		 }
		 if(listitem==12+idx){//user options
            AllPlayerMenu("UserProfelOptions",playerid);
            return 1;
		 }


      }
	  else {
      }
      return 1;
   }
   if(dialogid == 5) {//меню действия
      if(response) {
         switch(listitem)
         {
            case 0:{
			          if(PlayerInfo[playerid][Jailed]){WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);return 0;}
			          format(str,sizeof(str),"*** %s (id: %d) приветствует Вас %s (id: %d) ***",PlayerInfo[playerid][Name],playerid,PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]); SendClientMessage(PlayerInfo[playerid][TargetID],0x00AA00AA,str);format(str,sizeof(str),"Вы поприветствовали %s (id: %d).",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);WriteEcho(str,playerid);}
            case 1:{
			          if(PlayerInfo[playerid][Jailed]){WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);return 0;}
					  format(str,sizeof(str),"*** %s (id: %d) пращаеться с Вами %s (id: %d) ***",PlayerInfo[playerid][Name],playerid,PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]); SendClientMessage(PlayerInfo[playerid][TargetID],0xAA0000AA,str);format(str,sizeof(str),"Вы попрощались с %s (id: %d).",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);WriteEcho(str,playerid);}
			case 2:{format(str,sizeof(str),"ПМ для %s (id: %d)",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);WriteEcho("",playerid,-1,2,12,str,"Введите текст сообщения:","Отправить","Отмена");}//пм
            case 3:{
			          if(PlayerInfo[playerid][Jailed]){WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);return 0;}
					  format(str,sizeof(str),"Перевести денег для %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);WriteEcho("",playerid,-1,2,11,str,"Введите сумму","Передать","Отмена");}//передать бабло
            case 4:{
			          if(PlayerInfo[playerid][Jailed]){WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);return 0;}
					  if (gduel==0) format(str,sizeof(str),"Вы хотите вызнать %s на дуэль?", PlayerInfo[PlayerInfo[playerid][TargetID]][Name]); WriteEcho("",playerid,-1,3,2005,"Вызов на дуэль",str,"Да","Нет"); gDuelTetATet=1;
                      if (gduel==1){
	                     if (playerid==gplay1){ format(str,sizeof(str),"Вы уже вызвали %s на дуэль\nхотите отказаться?", PlayerInfo[PlayerInfo[playerid][TargetID]][Name]); WriteEcho("",playerid,-1,3,2002,"Дуэль",str,"Да","Нет");}
			             else WriteEcho("",PlayerInfo[playerid][TargetID],-1,3,2003,"Дуэль","Принять дуэль?","Да","Нет");
                      }
	                  if (gduel==2) WriteEcho("",playerid,-1,3,2004,"Ошибка","Дуэль проходит в данный момент.","OK","Отмена");
			       }//вызвать на дуэль
            case 5:{
			          if(PlayerInfo[playerid][Jailed]){WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);return 0;}
					  format(str,sizeof(str),"Жалуемся на %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);WriteEcho("",playerid,-1,2,15,str,"Введите причину:","Отправить","Отмена");}//жалоба
            case 6:{
			          if(PlayerInfo[playerid][Jailed]){WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);return 0;}
					  WriteEcho("Не выбрана ни одна опция.",playerid,ErrorMsgColor);}//сплоит

         }
         if(PlayerInfo[playerid][Jailed]){
		    WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
			return 1;
		 }
		 if(PlayerInfo[playerid][Admin]>PlayerInfo[PlayerInfo[playerid][TargetID]][Admin]){
            switch(listitem)
            {
		       case 7:{
                  if(!PlayerInfo[PlayerInfo[playerid][TargetID]][Jailed]){
			         format(str,sizeof(str),"Сейчас засудим %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
				     WriteEcho("",playerid,-1,2,16,str,"Введите время и прничину\n(Пример: 1 дб)","Посадить","Отмена");
				     return 1;
				  }
				  else {
                     format(str,sizeof(str),"Глубоко сидячий %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
			         WriteEcho("",playerid,-1,3,17,str,"Игрок сидит в тюрьме\nВыпустить?","Выпустить","Сиди");
		             return 1;
				  }
			   }//тюрьма
		       case 8:{
                  if(!PlayerInfo[PlayerInfo[playerid][TargetID]][Mute]){
			         format(str,sizeof(str),"Заткнуть %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
				     WriteEcho("",playerid,-1,2,21,str,"Введите время и прничину\n(Пример: 1 мат)","Заткнуть","Отмена");
				     return 1;
				  }
				  else {
                     format(str,sizeof(str),"Молчун %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
			         WriteEcho("",playerid,-1,3,22,str,"Игрок заткнут\nПрастить?","Прастить","Нет");
		             return 1;
				  }
			   }//мут
		       case 9:{AllCommandsReturn("freeze",playerid,PlayerInfo[playerid][TargetID]);}//заморозка
		       case 10:{AllCommandsReturn("disarm",playerid,PlayerInfo[playerid][TargetID]);}//обезоружить
		       case 11:{format(str,sizeof(str),"Выгнать %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);WriteEcho("",playerid,-1,2,19,str,"Укажате причину:","Выгнать","Отмена");}//Кикнуть
			}
		    if(!PlayerInfo[PlayerInfo[playerid][TargetID]][Admin]){
		       switch(listitem)
               {
		          case 12:{format(str,sizeof(str),"Забанить %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);WriteEcho("",playerid,-1,2,20,str,"Укажате причину:","Забанить","Отмена");}//Бан
		          case 13:{AllCommandsReturn("outcar",playerid,PlayerInfo[playerid][TargetID]);}//выкинуть из авто
		          case 14:{AllPlayerMenu("teleportmenu",playerid);}//Переместить
		          case 15:{AllCommandsReturn("goto",playerid,PlayerInfo[playerid][TargetID]);}//тп к игроку
		          case 16:{AllCommandsReturn("gethere",playerid,PlayerInfo[playerid][TargetID]);}//тп игрока к себе
		          case 17:{AllCommandsReturn("rape",playerid,PlayerInfo[playerid][TargetID]);}//казнить
		          case 18:{AllCommandsReturn("heal",playerid,PlayerInfo[playerid][TargetID]);}//вылечить
		          case 19:{WriteEcho("Данная опция в разработке.",playerid,ErrorMsgColor);}//дать админку
		       }
		    }
			else{
		       switch(listitem)
               {
                  case 12:{AllCommandsReturn("outcar",playerid,PlayerInfo[playerid][TargetID]);}//выкинуть из авто
		          case 13:{AllPlayerMenu("teleportmenu",playerid);}//Переместить
		          case 14:{AllCommandsReturn("goto",playerid,PlayerInfo[playerid][TargetID]);}//тп к игроку
		          case 15:{AllCommandsReturn("gethere",playerid,PlayerInfo[playerid][TargetID]);}//тп игрока к себе
		          case 16:{AllCommandsReturn("rape",playerid,PlayerInfo[playerid][TargetID]);}//казнить
		          case 17:{AllCommandsReturn("heal",playerid,PlayerInfo[playerid][TargetID]);}//вылечить
		          case 18:{AllCommandsReturn("gm",playerid,PlayerInfo[playerid][TargetID]);}//GM
		          case 19:{WriteEcho("Данная опция в разработке.",playerid,ErrorMsgColor);}//дать админку
		       }
	        }
         }
         else {
			switch(listitem)
			{
			   case 7:{AllPlayerMenu("teleportmenu",playerid);}//переместить
			   case 8:{AllCommandsReturn("goto",playerid,PlayerInfo[playerid][TargetID]);}//тп к игроку
			   case 9:{AllCommandsReturn("gethere",playerid,PlayerInfo[playerid][TargetID]);}//тп к себе
			   case 10:{AllCommandsReturn("heal",playerid,PlayerInfo[playerid][TargetID]);}//лечить
			   case 11:{AllCommandsReturn("gm",playerid,PlayerInfo[playerid][TargetID]);}//гм
			   case 12:{WriteEcho("Данная опция в разработке.",playerid,ErrorMsgColor);}//дать админку
			}
         }

      }
	  else {
         return 0;
      }
      return 1;
   }
   if(dialogid == 6) {//меню админа
      if(response) {
         switch(listitem)
		 {
            case 0:{AllCommandsReturn("acolor",playerid,playerid);}//цвет админа
            case 1:{AllCommandsReturn("say",playerid,playerid);}//Сказать
            case 2:{AllCommandsReturn("announce",playerid,playerid);}//Объявить
            case 3:{AllPlayerMenu("teleportmenu",playerid);PlayerInfo[playerid][TargetID]=playerid;}//Переместиться
            case 4:{AllCommandsReturn("tocar",playerid,playerid);}//Переместиться к авто
            case 5:{AllCommandsReturn("settime",playerid,playerid);}//Установит время
            case 6:{AllCommandsReturn("heall",playerid,playerid);}//Читать ПМ'мы
            case 7:{AllCommandsReturn("heal",playerid,playerid);}//Выличиться
            case 8:{AllCommandsReturn("gm",playerid,playerid);}//Бессмертие
            case 9:{AllCommandsReturn("globalsave",playerid,playerid);}//Сохранение
            case 10:{AllCommandsReturn("gamemodeexit",playerid,playerid);}//Перезапуск мода
            case 11:{AllPlayerMenu("GameModeOptions",playerid);}
         }
      }
	  else {
		 return 1;
      }
      return 1;
   }
   if(dialogid == 7) {
      if(response) {
         new title[MAX_STRING];
         if(WeaponInfo[listitem][IsWeaponMelee]==false){
            new tmp[MAX_STRING],idx;
	        tmp = strtok(inputtext,idx);
		    format(title,sizeof(title),"Покупка \"%s\":",GetWeaponNameRu(WeaponInfo[listitem][WeaponID]));
		    format(str,sizeof(str),"Стоимость одного боеприпаса $%d\nВведите необходимое количество\nбоепрпасов:",WeaponInfo[listitem][WeaponCost]);
		    WriteEcho("",playerid,-1,2,8,title,str,"Купить","Отмена");
            gPlayerSelect=listitem;
         }
         else {
            if (PlayerInfo[playerid][Moneys] < WeaponInfo[listitem][WeaponCost]) {
			format(str,sizeof(str),"У тебя недостаточно денег ($%d)",WeaponInfo[listitem][WeaponCost]);
			WriteEcho(str,playerid,ErrorMsgColor);
			return 1;
		    }
		    GivePlayerWeapon(playerid,WeaponInfo[listitem][WeaponID],1);
		    PlayerInfo[playerid][WeaponIDs][WeaponInfo[listitem][WeaponGroup]] = listitem;
		    PlayerInfo[playerid][WeaponAmmos][WeaponInfo[listitem][WeaponGroup]] = 1;
		    GiveMoney(playerid,-WeaponInfo[listitem][WeaponCost]);
		    format(str,sizeof(str),"%s (id: %d) bought weapon %s (id: %d) (shop id: %d)",PlayerInfo[playerid][Name],playerid,WeaponNames[WeaponInfo[listitem][WeaponID]],WeaponInfo[listitem][WeaponID],listitem);
		    WriteToLog(str);
		    format(str,sizeof(str),"Ты купил(а) %s (id: %d) за $%d",GetWeaponNameRu(WeaponInfo[listitem][WeaponID]),listitem,WeaponInfo[listitem][WeaponCost]);
		    WriteEcho(str,playerid);
         }
      }
	  else {
		 return 0;
      }
      return 1;
   }
   if(dialogid == 8) {
      if(response) {
        new tmp[MAX_STRING],idx;
	    tmp = strtok(inputtext,idx);
	    if (!strlen(tmp)) {
	    WriteEcho("",playerid,-1,2,8,"Покупка оружия. Ошибка.","Вы не указали количество\nбиоприпасов","Купить","Отмена");
	    return 1;
	    }
	    new weaponid = gPlayerSelect;
		new ammo = strval(tmp);
		if (ammo <= 0) {
		WriteEcho("",playerid,-1,2,8,"Покупка оружия. Ошибка.","Вы не указали количество\nбиоприпасов","Купить","Отмена");
		return 1;
		}
		new moneys = WeaponInfo[weaponid][WeaponCost]*ammo;
		if (PlayerInfo[playerid][Moneys] < moneys) {
        format(str,sizeof(str),"У тебя недостаточно денег ($%d)",moneys);
		WriteEcho(str,playerid,ErrorMsgColor);
		return 1;
		}
		GivePlayerWeapon(playerid,WeaponInfo[weaponid][WeaponID],ammo);
		if (weaponid == PlayerInfo[playerid][WeaponIDs][WeaponInfo[weaponid][WeaponGroup]]) PlayerInfo[playerid][WeaponAmmos][WeaponInfo[weaponid][WeaponGroup]] += ammo;
		else {
		PlayerInfo[playerid][WeaponIDs][WeaponInfo[weaponid][WeaponGroup]] = weaponid;
		PlayerInfo[playerid][WeaponAmmos][WeaponInfo[weaponid][WeaponGroup]] = ammo;
		}
		GiveMoney(playerid,-moneys);
		format(str,sizeof(str),"%s (id: %d) bought weapon %s (id: %d) (shop id: %d) (ammo: %d)",PlayerInfo[playerid][Name],playerid,WeaponNames[WeaponInfo[weaponid][WeaponID]],WeaponInfo[weaponid][WeaponID],weaponid,ammo);
		WriteToLog(str);
		format(str,sizeof(str),"Ты купил(а) %s (id: %d) и %d патронов за $%d",GetWeaponNameRu(WeaponInfo[weaponid][WeaponID]),weaponid,ammo,moneys);
		WriteEcho(str,playerid);
      }
	  else {
		 return 0;
      }
      return 1;
   }
   if(dialogid == 9) {//термины. расшифровка
      if(response) {
		 switch(listitem)
		 {
            case 0:{WriteEcho("- Ping (пинг) - это временной промежуток (в миллисекундах), за который пакет,",playerid,HelpMsgColor);WriteEcho(" отосланный от вашего компьютера проходит до сервера (и наоборот).",playerid,HelpMsgColor);}
            case 1:{WriteEcho("- Нуб - термин употребляемый игроками массовых ролевых онлайн игр,",playerid,HelpMsgColor);WriteEcho(" изначально происходит от английского newbie (новичек). Синонимы: Ньюб, зеленый.",playerid,HelpMsgColor);}
            case 2:{WriteEcho("- lol - сокращение от Laughing Out Loud, означает: я умираю от смеха.",playerid,HelpMsgColor);}
            case 3:{WriteEcho("- Ламер - это чайник, который думает, что круто заварен.",playerid,HelpMsgColor);}
            case 4:{WriteEcho("- Капсить - писать сообщения в верхнем регистре, крайне не приветствуется в чатах без особой на то нужды.",playerid,HelpMsgColor);WriteEcho(" Термин происходит от названия кнопки «Caps Lock», позволяющей писать в верхнем регистре без нажатия клавиши «Shift».",playerid,HelpMsgColor);}
            case 5:{WriteEcho("- Чит - это Код в игре, дающий какие-либо бонусы.",playerid,HelpMsgColor);}
            case 6:{WriteEcho("- Баг +С - подробно об этом термине читайте на нашем форуме: http://www.jru-team.ru/forum/",playerid,HelpMsgColor);}
         }
      }
	  else {
		 return 0;
      }
      return 1;
   }
   if(dialogid == 10) {
      if(response) {
	     new tmp[MAX_STRING],idx;
		 tmp = strtok(inputtext,idx);
	     if (!strlen(tmp)) {
	        WriteEcho("",playerid,-1,2,10,"Смена пароля. Ошибка.","Пароль не может быть пустым!\nВведите новый пароль:","Сменить","Отмена");
	     }
	     if (strlen(tmp) < 5) {
		    WriteEcho("Пароль должен состоять минимум из 5 символов",playerid,ErrorMsgColor);
		    WriteEcho("",playerid,-1,2,10,"Смена пароля. Ошибка.","Введите новый пароль:","Сменить","Отмена");
	     }
	     else {
	        PlayerInfo[playerid][Password] = num_hash(tmp);
	        format(str,sizeof(str),"%s (id: %d) changed his password",PlayerInfo[playerid][Name],playerid);
	        WriteToLog(str);
	        format(str,sizeof(str),"Вы сменили свой пароль. Ваш новый пароль: %s. Не забудте его!",tmp);
	        WriteEcho(str,playerid);
	     }
      }
	  else {
		 return 0;
      }
      return 1;
   }
   if(dialogid == 11) {//передача бабла
      if(response) {
         new tmp[MAX_STRING],idx;
	     tmp = strtok(inputtext,idx);
	     if (!strlen(tmp)) {
		    format(str,sizeof(str),"Перевести денег для %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
			WriteEcho("",playerid,-1,2,11,str,"Ошибка: Вы не указали сумму.\nВведите сумму","Передать","Отмена");
		    return 1;
	     }
	     new targetid = PlayerInfo[playerid][TargetID];
	     if (!IsPlayerConnected(targetid)) {
		    format(str,sizeof(str),"Игрок с ид %d не подключен к серверу.",targetid);
		    WriteEcho(str,playerid,ErrorMsgColor);
		    return 1;
	     }
	     new amount = strval(tmp);
	     if (amount <= 0) {
		    format(str,sizeof(str),"Вы вели не допустимую сумму ($%d)",amount);
		    WriteEcho(str,playerid,ErrorMsgColor);
		    return 1;
	     }
	     if (PlayerInfo[playerid][Moneys] < amount) {
		    format(str,sizeof(str),"У вас не достаточно денег денег ($%d)",amount);
		    WriteEcho(str,playerid,ErrorMsgColor);
		    return 1;
	     }
	     GiveMoney(playerid,-amount);
	     GiveMoney(targetid,amount);
	     format(str,sizeof(str),"%s (id: %d) sent $%d to %s (id: %d)",PlayerInfo[playerid][Name],playerid,amount,PlayerInfo[targetid][Name],targetid);
	     WriteToLog(str);
	     format(str,sizeof(str),"Вы передали $%d %s (id: %d)",amount,PlayerInfo[targetid][Name],targetid);
	     WriteEcho(str,playerid);
	     format(str,sizeof(str),"Вы палучили $%d от %s (id: %d)",amount,PlayerInfo[playerid][Name],playerid);
	     WriteEcho(str,targetid);
	     return 1;
	  }
	  else {
		 return 1;
      }
   }
   if(dialogid == 12) {//ПМ
      if(response) {
         new tmp[MAX_STRING],idx;
	     tmp = strtok(inputtext,idx);
	     if (!strlen(tmp)) {
		    format(str,sizeof(str),"ПМ для %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
			WriteEcho("",playerid,-1,2,12,str,"Ошибка: Нельзя отправить пустое ПМ.\nВведите текст сообщения","Отправить","Отмена");
		    return 1;
	     }
	     new targetid = PlayerInfo[playerid][TargetID];
	     if (!IsPlayerConnected(targetid)) {
		    format(str,sizeof(str),"Игрок с ид %d не подключен к серверу.",targetid);
		    WriteEcho(str,playerid,ErrorMsgColor);
		    return 1;
	     }
	     if(PlayerInfo[targetid][AFK]){
            format(str,sizeof(str),"Сообщение для %s (id: %d) не доставленно. Игрок находиться в AFK.",PlayerInfo[targetid][Name],targetid);
            WriteEcho(str,playerid,ErrorMsgColor);
			return 0;
		 }
	     format(str,sizeof(str),"ПМ для %s (id: %d): %s",PlayerInfo[targetid][Name],targetid,inputtext);
		 WriteEcho(str,playerid,SystemMsgColor);
         if(PlayerInfo[targetid][PMType]==0){
			if(PlayerInfo[targetid][PMSelectType]==0){
			   WriteEcho("",targetid,-1,3,13,"Настройки ПМ","Вы хатите в дольнейшем\nполучать всплываещие ПМ сообщения?","Да","Нет");
			   PlayerInfo[targetid][TargetID]=playerid;
	           format(gPrivatMsg,sizeof(gPrivatMsg),"%s",inputtext);
			}
			else {
			   format(str,sizeof(str),"ПМ от %s (id: %d):",PlayerInfo[playerid][Name],playerid);
			   WriteEcho("",targetid,-1,3,14,str,tmp,"Ответить","Отмена");
			}
         }
         else {
		    format(str,sizeof(str),"ПМ от %s (id: %d) для %s (id: %d): %s",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,inputtext);
            if(!IsPlayerAdmin(playerid) && !IsPlayerAdmin(targetid)) for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && PlayerInfo[i][Admin] > PlayerInfo[playerid][Admin] && PlayerInfo[i][Admin] > PlayerInfo[targetid][Admin] && PlayerInfo[i][HearAll]) WriteEcho(str,i,PrivateMsgColor);
            if (PlayerInfo[targetid][Ignores][playerid]) return 0;
            format(str,sizeof(str),"ПМ от %s (id: %d): %s",PlayerInfo[playerid][Name],playerid,inputtext);
			WriteEcho(str,targetid,PrivateMsgColor);


         }
	     return 1;
	  }
	  else {
         return 0;
      }
   }
   if(dialogid == 13) {//настройка типа пм
      if(response) {
         PlayerInfo[playerid][PMType]=0;
         PlayerInfo[playerid][PMSelectType]=1;
		 format(str,sizeof(str),"ПМ от %s (id: %d) для %s (id: %d): %s",PlayerInfo[playerid][Name],playerid,PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID],gPrivatMsg);
         if(!IsPlayerAdmin(playerid) && !IsPlayerAdmin(PlayerInfo[playerid][TargetID])) for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && PlayerInfo[i][Admin] > PlayerInfo[playerid][Admin] && PlayerInfo[i][Admin] > PlayerInfo[PlayerInfo[playerid][TargetID]][Admin] && PlayerInfo[i][HearAll]) WriteEcho(str,i,PrivateMsgColor);
         if (PlayerInfo[playerid][Ignores][PlayerInfo[playerid][TargetID]]) return 0;
         format(str,sizeof(str),"ПМ от %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name]);
		 WriteEcho("",playerid,-1,3,14,str,gPrivatMsg,"Ответить","Отмена");

	     return 1;
	  }
	  else {
	     format(str,sizeof(str),"ПМ от %s (id: %d) для %s (id: %d): %s",PlayerInfo[playerid][Name],playerid,PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID],gPrivatMsg);
         if(!IsPlayerAdmin(playerid) && !IsPlayerAdmin(PlayerInfo[playerid][TargetID])) for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && PlayerInfo[i][Admin] > PlayerInfo[playerid][Admin] && PlayerInfo[i][Admin] > PlayerInfo[PlayerInfo[playerid][TargetID]][Admin] && PlayerInfo[i][HearAll]) WriteEcho(str,i,PrivateMsgColor);
         if (PlayerInfo[playerid][Ignores][PlayerInfo[playerid][TargetID]]) return 0;
         format(str,sizeof(str),"ПМ от %s (id: %d): %s",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID],gPrivatMsg);
         WriteEcho(str,playerid,PrivateMsgColor);
         PlayerInfo[playerid][PMType]=1;
      }
   }
   if(dialogid == 14) {//ответ на пм
      if(response) {
		 format(str,sizeof(str),"ПМ для %s (id: %d)",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
		 WriteEcho("",playerid,-1,2,12,str,"Введите текст сообщения:","Отправить","Отмена");
	     return 1;
	  }
	  else {
		 return 1;
      }
   }
   if(dialogid == 15) {//стучалка xD
      if(response) {
         new tmp[MAX_STRING],idx;
	     tmp = strtok(inputtext,idx);
	     if (!strlen(tmp)) {
		    format(str,sizeof(str),"Жалуемся на %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
			WriteEcho("",playerid,-1,2,15,str,"Ошибка. Не указана причина.\nВведите причину:","Отправить","Отмена");
		    return 1;
	     }
	     new targetid = PlayerInfo[playerid][TargetID];
	     if (targetid == playerid) {
		    WriteEcho("Нельзя жаловатся на себя",playerid,ErrorMsgColor);
		    return 1;
	     }
	     if (!IsPlayerConnected(targetid)) {
		    format(str,sizeof(str),"Игрок с id %d не подключен к серверу",targetid);
		    WriteEcho(str,playerid,ErrorMsgColor);
		    return 1;
	     }
	     if (IsPlayerAdmin(targetid) || PlayerInfo[targetid][Admin]) {
		    format(str,sizeof(str),"Совсем совесть потерял(а)? На админа (%s (id: %d)) жаловаться",PlayerInfo[targetid][Name],targetid);
		    WriteEcho(str,playerid,ErrorMsgColor);
		    return 1;
	     }
	     format(str,sizeof(str),"Игрок %s (id: %d) жалуется на %s (id: %d): %s",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,inputtext);
	     WriteToLog(str);
	     #if defined AdminsLog
		    WriteToLog(str,AdminsLog);
	     #endif
	     for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
         WriteEcho("Твоя жалоба направлена админам",playerid);
	     return 1;
	  }
	  else {
		 return 1;
      }
   }
   if(dialogid == 16) {//тюрьма
      if(response) {
         new tmp[MAX_STRING],idx;
	     tmp = strtok(inputtext,idx);
		 new targetid = PlayerInfo[playerid][TargetID];
         if(!PlayerInfo[targetid][Jailed]){
            if(!strlen(tmp)){
               format(str,sizeof(str),"Сейчас засудим %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
			   WriteEcho("",playerid,-1,2,16,str,"Ошибка. Не указанно время!\nВведите время и прничину\n(Пример: 1 дб)","Посадить","Отмена");
		    }
	        if (targetid == playerid) {
		       SendClientMessage(playerid,0xFF0000AA,"* Вы не можете посадить себя в тюрьму.");
		       return 1;
	        }
	        if (!IsPlayerConnected(targetid)) {
		       format(str,sizeof(str),"Вы не можете посадить в тюрьму несуществующих игроков (%d)",targetid);
		       WriteEcho(str,playerid,MuteMsgColor);
		       return 1;
	        }
	        if (IsPlayerAdmin(targetid) || PlayerInfo[targetid][Admin] >= PlayerInfo[playerid][Admin]) {
		       format(str,sizeof(str),"%s (id: %d) отвали отменя! У меня уровень выше!",PlayerInfo[targetid][Name],targetid);
		       WriteEcho(str,playerid,MuteMsgColor);
		       return 1;
	        }
	        new tmp2[MAX_STRING];
	        tmp2 = strtok(inputtext,idx);
	        if (!strlen(tmp2)) {
		       format(str,sizeof(str),"Сейчас засудим %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
			   WriteEcho("",playerid,-1,2,16,str,"Ошибка. Не указанна причина!\nВведите время и прничину\n(Пример: 1 дб)","Посадить","Отмена");
		       return 1;
	        }
	        new duration = strval(tmp);
	        if (duration < 1) {
		       format(str,sizeof(str),"Вы не можете посадить в тюрьму игрока на это время (%d).",duration);
		       WriteEcho(str,playerid,MuteMsgColor);
		       return 1;
	        }
	        format(str,sizeof(str),"%s \"%s (id: %d)\" посадил в тюрьму \"%s (id: %d)\" на %dмин. Причина: %s",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,duration,inputtext[1]); WriteEcho(str,INVALID_PLAYER_ID,MuteMsgColor);
	        PlayerInfo[targetid][Jailed] = true; SetPlayerInterior(targetid,3); SetPlayerPos(targetid,197.6661,173.8179,1003.0234); SetPlayerFacingAngle(targetid,0);
	        PlayerInfo[targetid][Jailed] = duration;
	        TogglePlayerControllable(targetid, 0);
	        ResetPlayerWeapons(targetid);
	        PlayerInfo[targetid][JailedTime] = SetTimerEx("UnJailedPlayerT",duration*60000,0,"i",targetid);
	        return 1;
         }
         else if(PlayerInfo[targetid][Jailed]){
		    if(IsPlayerConnected(targetid) && targetid != INVALID_PLAYER_ID) {
	           format(str,sizeof(str),"Глубоко сидячий %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);

			   return 1;
		    }
			WriteEcho("Ошибка: Вы не можете выпустить из тюрьмы несуществующего игрока.",playerid,MuteMsgColor); return 0;
         }
	  }
	  else {
		 return 1;
      }
   }
   if(dialogid == 17) {//тюрьма
      if(response) {
	     new targetid = PlayerInfo[playerid][TargetID];
   		 new tmp[MAX_STRING],idx;
	     tmp = strtok(inputtext,idx);
	     if (!strlen(tmp)) {
		    format(str,sizeof(str),"Глубоко сидячий %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
			WriteEcho("",playerid,-1,2,17,str,"Укажите причину:","Выпустить","Неет!");
		    return 1;
	     }
		 if(IsPlayerConnected(targetid) && targetid != INVALID_PLAYER_ID) {
			if(targetid != playerid) {
			format(str,sizeof(str),"%s \"%s (id: %d)\" выпустил из тюрьмы \"%s (id: %d)\". Причина: %s",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,inputtext); WriteEcho(str,INVALID_PLAYER_ID,MuteMsgColor); }
			else {
			   WriteEcho("Ты не можешь выпустить себя из тюрьмы.",playerid,0xFFFF00AA);
			   return 0;
			}
			PlayerInfo[targetid][Jailed] = false; KillTimer(PlayerInfo[targetid][JailedTime]); SetPlayerInterior(targetid,0); SetPlayerPos(targetid,2343.1265,2457.8074,14.9688); SetPlayerFacingAngle(targetid,0); TogglePlayerControllable(targetid, 1);
			return 1;
		 } WriteEcho("Ошибка: Вы не можете выпустить из тюрьмы несуществующего игрока.",playerid,MuteMsgColor); return 0;
	  }
	  else {
		 return 1;
      }
   }
   switch(dialogid)
   {
      case 18:{if(response) gPlayerSelect=listitem;AllCommandsReturn("teleport",playerid,PlayerInfo[playerid][TargetID]);}//переместить
      case 19:{if(response) AllCommandsReturn("kick",playerid,PlayerInfo[playerid][TargetID],-1,inputtext);}//кик
      case 20:{if(response) AllCommandsReturn("ban",playerid,PlayerInfo[playerid][TargetID],-1,inputtext);}//бан
      case 21:{if(response) AllCommandsReturn("mute",playerid,PlayerInfo[playerid][TargetID],-1,inputtext);}//заткнуть
      case 22:{if(response) AllCommandsReturn("unmute",playerid,PlayerInfo[playerid][TargetID],-1,inputtext);}//прастить
      case 23:{if(response) AllCommandsReturn("say",playerid,playerid,-1,inputtext);}//сказать (меню админа)
      case 24:{if(response) AllCommandsReturn("announce",playerid,playerid,-1,inputtext);}//объявить (меню админа)
      case 25:{if(response) AllCommandsReturn("tocar",playerid,playerid,-1,inputtext);}//ТП к авто (меню админа)
      case 26:{if(response) AllCommandsReturn("settime",playerid,playerid,-1,inputtext);}//установить время (меню админа)
   }
   if(dialogid == 27) {//настройки профиля
      if(response) {
		 switch(listitem)
		 {
	        case 0:{WriteEcho("Данная опция в разработке",playerid,ErrorMsgColor);}
	        case 1:{
			   if(!PlayerInfo[playerid][LogginType]) {PlayerInfo[playerid][LogginType]=1; AllPlayerMenu("UserProfelOptions",playerid);}
			   else PlayerInfo[playerid][LogginType]=0; AllPlayerMenu("UserProfelOptions",playerid);}
			case 2:{
			   if(PlayerInfo[playerid][PMType]) {PlayerInfo[playerid][PMType]=0; AllPlayerMenu("UserProfelOptions",playerid);}
			   else PlayerInfo[playerid][PMType]=1; AllPlayerMenu("UserProfelOptions",playerid);}
		 }
	  }
	  else {
		 return 1;
      }
   }
   #if defined HousesOnOff
   if(dialogid == 550) {
		if(response) {
			if (listitem == 0) {
				ShowPlayerDialog(playerid,551,DIALOG_STYLE_INPUT,"АССД (by kroks)","Сохранение позиции для входа в  дом\n\nВведите номер дома или поставте 0 для нового","Да","Да нах");
			}
			else if (listitem == 1) {
   				ShowPlayerDialog(playerid,552,DIALOG_STYLE_INPUT,"АССД (by kroks)","Сохранение позиции для выхода из  дома\n\nВведите номер дома или поставте 0 для нового","Да","Да нах");
			}
			else if (listitem == 2) {
   				ShowPlayerDialog(playerid,553,DIALOG_STYLE_INPUT,"АССД (by kroks)","Сохранение позиции для спавна в  доме\n\nВведите номер дома или поставте 0 для нового","Да","Да нах");
			}
			else if (listitem == 3) {
                reloadhouses();
			}
			else if (listitem == 4) {
                ShowPlayerDialog(playerid,554,DIALOG_STYLE_INPUT,"АССД (by kroks)","Сохранение владельца\n\nВведите номер дома и ник или поставте 0 для нового\n\nПример: '1 [JRU]S_S'","Да","Да нах");
			}
			else if (listitem == 5) {
                ShowPlayerDialog(playerid,555,DIALOG_STYLE_INPUT,"АССД (by kroks)","Сохранение интерьера\n\nВведите номер дома и номер инт.(1-7) или поставте 0 для нового\n\nПример: '1 1'","Да","Да нах");
			}
		} else {
		    SendClientMessage(playerid, 0xFFFFFFFF, "И нах было писать?");
		}
		return 1; // we processed it.
	}
	if(dialogid == 551) {
	    if(response) {
	    new i,idx;
 		i = strval(strtok(inputtext,idx));
 		if (i!=0){
 		new Float:x, Float:y, Float:z;
   		GetPlayerPos(playerid, x, y, z);
   		houses[i][X_h_in]=x;
    	houses[i][Y_h_in]=y;
    	houses[i][Z_h_in]=z;
    	if (!dini_Exists(HousesFile(i))){
    	dini_Create(HousesFile(i));
    	dini_IntSet("simpledm/houses/main.txt","all",houses_load+1);
    	houses_load++;
    	new mss[MAX_STRING];
        format(mss,sizeof(mss),"Новый идентификатор дома #%d",i);
        SendClientMessage(playerid, 0xFFFFFFFF, mss);
   		}
    	dini_FloatSet(HousesFile(i),"IN_X",x);
    	dini_FloatSet(HousesFile(i),"IN_Y",y);
    	dini_FloatSet(HousesFile(i),"IN_Z",z);

 		}
 		else
 		{
 		addhouse();
 		i=houses_load;
		new Float:x, Float:y, Float:z;
   		GetPlayerPos(playerid, x, y, z);
   		houses[i][X_h_in]=x;
    	houses[i][Y_h_in]=y;
    	houses[i][Z_h_in]=z;
    	dini_FloatSet(HousesFile(i),"IN_X",x);
    	dini_FloatSet(HousesFile(i),"IN_Y",y);
    	dini_FloatSet(HousesFile(i),"IN_Z",z);
    	new mss[MAX_STRING];
        format(mss,sizeof(mss),"Новый идентификатор дома #%d",i);
        SendClientMessage(playerid, 0xFFFFFFFF, mss);

 		}

	    } else {
		    SendClientMessage(playerid, 0xFFFFFFFF, "И нах было нажимать?");
		}
		return 1; // we processed it.
	}
	if(dialogid == 552) {
	    if(response) {
	    new i,idx;
 		i = strval(strtok(inputtext,idx));
        if (i!=0){
		new inter;
		inter=GetPlayerInterior(playerid);
		houses[i][inter_h]=inter;
        new Float:x, Float:y, Float:z;
   		GetPlayerPos(playerid, x, y, z);
   		houses[i][X_h_out]=x;
    	houses[i][Y_h_out]=y;
    	houses[i][Z_h_out]=z;


    	if (!dini_Exists(HousesFile(i))){
    	dini_Create(HousesFile(i));
    	dini_IntSet("simpledm/houses/main.txt","all",houses_load+1);
    	houses_load++;
    	new mss[MAX_STRING];
        format(mss,sizeof(mss),"Новый идентификатор дома #%d",i);
        SendClientMessage(playerid, 0xFFFFFFFF, mss);
   		}
    	dini_FloatSet(HousesFile(i),"OUT_X",x);
    	dini_FloatSet(HousesFile(i),"OUT_Y",y);
    	dini_FloatSet(HousesFile(i),"OUT_Z",z);
    	dini_IntSet(HousesFile(i),"INTER",inter);

 		}
 		else
 		{
		addhouse();
 		i=houses_load;
        new inter;
		inter=GetPlayerInterior(playerid);
		houses[i][inter_h]=inter;
        new Float:x, Float:y, Float:z;
   		GetPlayerPos(playerid, x, y, z);
   		houses[i][X_h_out]=x;
    	houses[i][Y_h_out]=y;
    	houses[i][Z_h_out]=z;
        dini_IntSet(HousesFile(i),"INTER",inter);
    	dini_FloatSet(HousesFile(i),"OUT_X",x);
    	dini_FloatSet(HousesFile(i),"OUT_Y",y);
    	dini_FloatSet(HousesFile(i),"OUT_Z",z);    	new mss[MAX_STRING];
        format(mss,sizeof(mss),"Новый идентификатор дома #%d",i);
        SendClientMessage(playerid, 0xFFFFFFFF, mss);
 		}
	    } else {
		    SendClientMessage(playerid, 0xFFFFFFFF, "И нах было нажимать?");
		}
		return 1; // we processed it.
	}
	if(dialogid == 553) {
	    if(response) {
	    new i,idx;
 		i = strval(strtok(inputtext,idx));
        if (i!=0){
        new Float:x, Float:y, Float:z;
   		GetPlayerPos(playerid, x, y, z);
   		new inter;
		inter=GetPlayerInterior(playerid);
		houses[i][inter_h]=inter;
        houses[i][X_h_spawn]=x;
    	houses[i][Y_h_spawn]=y;
    	houses[i][Z_h_spawn]=z;
    	if (!dini_Exists(HousesFile(i))){
    	dini_Create(HousesFile(i));
    	new mss[MAX_STRING];
    	dini_IntSet("simpledm/houses/main.txt","all",houses_load+1);
    	houses_load++;
        format(mss,sizeof(mss),"Новый идентификатор дома #%d",i);
        SendClientMessage(playerid, 0xFFFFFFFF, mss);
   		}
    	dini_FloatSet(HousesFile(i),"SPAWN_X",x);
    	dini_FloatSet(HousesFile(i),"SPAWN_Y",y);
    	dini_FloatSet(HousesFile(i),"SPAWN_Z",z);
        dini_IntSet(HousesFile(i),"INTER",inter);
 		}
 		else
 		{
        new inter;
		inter=GetPlayerInterior(playerid);
		houses[i][inter_h]=inter;
        addhouse();
 		i=houses_load;
		new Float:x, Float:y, Float:z;
   		GetPlayerPos(playerid, x, y, z);
        houses[i][X_h_spawn]=x;
    	houses[i][Y_h_spawn]=y;
    	houses[i][Z_h_spawn]=z;
        dini_FloatSet(HousesFile(i),"SPAWN_X",x);
    	dini_FloatSet(HousesFile(i),"SPAWN_Y",y);
    	dini_FloatSet(HousesFile(i),"SPAWN_Z",z);
        dini_IntSet(HousesFile(i),"INTER",inter);
    	new mss[MAX_STRING];
        format(mss,sizeof(mss),"Новый идентификатор дома #%d",i);
        SendClientMessage(playerid, 0xFFFFFFFF, mss);
 		}
	    } else {
		    SendClientMessage(playerid, 0xFFFFFFFF, "И нах было нажимать?");
		}
		return 1; // we processed it.
	}
	if(dialogid == 554) { // Our example inputbox
		if(response) {
		new i,name[MAX_STRING],idx;
 		i = strval(strtok(inputtext,idx));
 		name=strtok(inputtext,idx);
 		if (i!=0){
 		if (!dini_Exists(HousesFile(i))){
    	dini_Create(HousesFile(i));
    	new mss[MAX_STRING];
    	dini_IntSet("simpledm/houses/main.txt","all",houses_load+1);
    	houses_load++;
        format(mss,sizeof(mss),"Новый идентификатор дома #%d",i);
        SendClientMessage(playerid, 0xFFFFFFFF, mss);
   		}
 		houses[i][user_h]=name;
 		dini_Set(HousesFile(i),"USER",name);
 		}
 		else
 		{
 		addhouse();
 		i=houses_load;
	 	houses[i][user_h]=name;
        dini_Set(HousesFile(i),"USER",name);
        new mss[MAX_STRING];
        format(mss,sizeof(mss),"Новый идентификатор дома #%d",i);
        SendClientMessage(playerid, 0xFFFFFFFF, mss);
 		}



		} else {
		    SendClientMessage(playerid, 0xFFFFFFFF, "А нах было вводить?");
		}
		return 1; // we processed it.
	}
	if(dialogid == 555) {
	    if(response) {
	    new i,intt,idx;
 		i = strval(strtok(inputtext,idx));
 		intt = strval(strtok(inputtext,idx));
 		if (!dini_Exists(HousesFile(i))){
    	dini_Create(HousesFile(i));
    	new mss[MAX_STRING];
    	dini_IntSet("simpledm/houses/main.txt","all",houses_load+1);
    	houses_load++;
        format(mss,sizeof(mss),"Новый идентификатор дома #%d",i);
        SendClientMessage(playerid, 0xFFFFFFFF, mss);
   		}
   		new msas[MAX_STRING];
   		switch (intt)
		{
		case 1:
		{
		dini_IntSet(HousesFile(i),"INTER",3);
    	dini_FloatSet(HousesFile(i),"OUT_X",235.5089);
    	dini_FloatSet(HousesFile(i),"OUT_Y",1189.169897);
    	dini_FloatSet(HousesFile(i),"OUT_Z",1080.339966);
    	format(msas,sizeof(msas),"Стандарт %d для дома %d",intt,i);
		}
		case 2:
		{
		dini_IntSet(HousesFile(i),"INTER",2);
    	dini_FloatSet(HousesFile(i),"OUT_X",225.756989);
    	dini_FloatSet(HousesFile(i),"OUT_Y",1240.000000);
    	dini_FloatSet(HousesFile(i),"OUT_Z",1082.149902);
    	format(msas,sizeof(msas),"Стандарт %d для дома %d",intt,i);
		}
		case 3:
		{
		dini_IntSet(HousesFile(i),"INTER",1);
    	dini_FloatSet(HousesFile(i),"OUT_X",223.043991);
    	dini_FloatSet(HousesFile(i),"OUT_Y",1289.259888);
    	dini_FloatSet(HousesFile(i),"OUT_Z",1082.199951);
    	format(msas,sizeof(msas),"Стандарт %d для дома %d",intt,i);
		}
		case 4:
		{
		dini_IntSet(HousesFile(i),"INTER",7);
    	dini_FloatSet(HousesFile(i),"OUT_X",225.630997);
    	dini_FloatSet(HousesFile(i),"OUT_Y",1022.479980);
    	dini_FloatSet(HousesFile(i),"OUT_Z",1084.069946);
    	format(msas,sizeof(msas),"Стандарт %d для дома %d",intt,i);
		}
		case 5:
		{
		dini_IntSet(HousesFile(i),"INTER",15);
    	dini_FloatSet(HousesFile(i),"OUT_X",295.138977);
    	dini_FloatSet(HousesFile(i),"OUT_Y",1474.469971);
    	dini_FloatSet(HousesFile(i),"OUT_Z",1080.519897);
    	format(msas,sizeof(msas),"Стандарт %d для дома %d",intt,i);
		}
		case 6:
		{
		dini_IntSet(HousesFile(i),"INTER",15);
    	dini_FloatSet(HousesFile(i),"OUT_X",328.493988);
    	dini_FloatSet(HousesFile(i),"OUT_Y",1480.589966);
    	dini_FloatSet(HousesFile(i),"OUT_Z",1084.449951);
    	format(msas,sizeof(msas),"Стандарт %d для дома %d",intt,i);
		}
		case 7:
		{
		dini_IntSet(HousesFile(i),"INTER",15);
    	dini_FloatSet(HousesFile(i),"OUT_X",385.803986);
    	dini_FloatSet(HousesFile(i),"OUT_Y",1471.769897);
    	dini_FloatSet(HousesFile(i),"OUT_Z",1080.209961);
    	format(msas,sizeof(msas),"Стандарт %d для дома %d",intt,i);
		}
		default:
		{
		dini_IntSet(HousesFile(i),"INTER",3);
    	dini_FloatSet(HousesFile(i),"OUT_X",235.5089);
    	dini_FloatSet(HousesFile(i),"OUT_Y",1189.169897);
    	dini_FloatSet(HousesFile(i),"OUT_Z",1080.339966);
    	format(msas,sizeof(msas),"Ошибка определения стандарта.(Установлен  %d для дома %d)",intt,i);
		}

		}
   		SendClientMessage(playerid, 0xFFFFFFFF, msas);
   		reloadhouses();



 		}
 		else
 		{

 		}
 		
	return 1;
	}
	#endif
    //дуэли by kroks_rus
	if(dialogid == 2000) { // меню оружия

		if(response) {
		gzone=listitem;
		new listitems[] = "1\tM4+MP5\n2\tM4+Shotgun\n3\tM4+Rifle\n4\tM4+Deagle\n5\tDeagle+AK-47\n6\tDeagle+MP5\n7\tSniper+Shotgun\n8\tSniper+AK-47\n9\tSniper+MP5\n10\tShotgun+Grenade\n11\tGrenate+M4\n12\tDeagle+Shotgun";
	    ShowPlayerDialog(playerid,2007,DIALOG_STYLE_LIST,"Выбор оружия....:",listitems,"Да","Отмена");

		}

		return 1;
	}
	if(dialogid == 2007) {

		if(response) {
		gweapon2=listitem;
		duels(playerid);

		}

		return 1;
	}

	if(dialogid == 2002) {
		if(response) {
  		noduel(playerid);
		}
		return 1;
	}
	if(dialogid == 2003) {
		if(response) {
  		duelj(playerid);
		}
		return 1;
	}
	if(dialogid == 2009) {
		if(response) {
  		stopduel(playerid);
		}
		return 1;
	}
	if(dialogid == 2004) {
		return 1;
	}
	if(dialogid == 2005) {
		if(response) {
  		new listitems[] = "1\tЗавод\n2\tАвианосец (ниж. пал.)\n3\tАвианосец (2 пал.)\n4\tКорабль";
	    ShowPlayerDialog(playerid,2000,DIALOG_STYLE_LIST,"Выбор места....:",listitems,"Да","Отмена");
		}
		return 1;
	}
   //дуэли by kroks_rus
   
   return 1;
}

#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0))) //проверка нажатой кнопки
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0))) //проверка отпущена ли кнопка
/*

KEY_ACTION
KEY_CROUCH - присесть(С)
KEY_FIRE - стрелять
KEY_SPRINT - бег
KEY_SECONDARY_ATTACK - авто вход/выход
KEY_JUMP - прыжок
KEY_LOOK_RIGHT - в авто смотреть направо
KEY_HANDBRAKE - прицел
KEY_LOOK_LEFT - в авто смотреть налево
KEY_SUBMISSION - num1 смотреть назад
KEY_LOOK_BEHIND - num1 смотреть назад
KEY_WALK - шаг (Alt)
KEY_ANALOG_UP
KEY_ANALOG_DOWN
KEY_ANALOG_LEFT
KEY_ANALOG_RIGHT
KEY_UP - вперед
KEY_DOWN - назад
KEY_LEFT - влево
KEY_RIGHT - вправо
*/

public OnPlayerUpdate(playerid)
{
   if (IsPlayerAdmin(playerid)) PlayerInfo[playerid][Admin] = 10;
   //античит
   new Float:armour,Float:health,weapons,str[MAX_STRING];
   GetPlayerArmour(playerid,armour); GetPlayerHealth(playerid,health); weapons=GetPlayerWeapon(playerid);
   if(PlayerInfo[playerid][Admin]<=0 && !IsPlayerNPC(playerid)){
      if(armour > 0){
		 //format(str,sizeof(str),"%s (ip: %d), забанен. Причина: Бронь",PlayerInfo[playerid][Name],PlayerInfo[playerid][PlayerIP]);
		 format(str,sizeof(str),"%s (ip: %d), кикнут. Причина: Бронь",PlayerInfo[playerid][Name],PlayerInfo[playerid][PlayerIP]);
		 WriteToLog(str,AntiCheatLog);
		 #if defined IrcOnOff
		    //format(str,sizeof(str),"04АНТИЧИТ. Игрок %s (ip: %d) забанен. Причина: Бронь",PlayerInfo[playerid][Name],PlayerInfo[playerid][PlayerIP]);
	        IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	     #endif
         //BanPlayer(playerid,"Бронь","АНТИЧИТОМ");
         KickPlayer(playerid,"Бронь","АНТИЧИТОМ");
      }
      if(health > 150){
		 //format(str,sizeof(str),"%s (ip: %d), забанен. Причина: Год мод",PlayerInfo[playerid][Name],PlayerInfo[playerid][PlayerIP]);
		 format(str,sizeof(str),"%s (ip: %d), кикнут. Причина: Год мод",PlayerInfo[playerid][Name],PlayerInfo[playerid][PlayerIP]);
		 WriteToLog(str,AntiCheatLog);
		 #if defined IrcOnOff
		    //format(str,sizeof(str),"04АНТИЧИТ. Игрок %s (ip: %d) забанен. Причина: Год Мод",PlayerInfo[playerid][Name],PlayerInfo[playerid][PlayerIP]);
	        IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	     #endif
         //BanPlayer(playerid,"Год мод","АНТИЧИТОМ");
         KickPlayer(playerid,"Год мод","АНТИЧИТОМ");
      }
      for (new i=0;i<CheatWeapons1;i++) {
		 if(weapons==CheatWeapon1[i]){
			format(str,sizeof(str),"Запрещенное оружие (%s)",GetWeaponNameRu(weapons));
			//BanPlayer(playerid,str,"АНТИЧИТОМ");
			KickPlayer(playerid,str,"АНТИЧИТОМ");
			format(str,sizeof(str),"%s (ip: %d), забанен. Причина: %s",PlayerInfo[playerid][Name],PlayerInfo[playerid][PlayerIP],str);
			WriteToLog(str,AntiCheatLog);
			#if defined IrcOnOff
			   //format(str,sizeof(str),"04АНТИЧИТ. Игрок %s (ip: %d) забанен. Причина: Запрещенное оружие (%s)",PlayerInfo[playerid][Name],PlayerInfo[playerid][PlayerIP],GetWeaponNameRu(weapons));
	           IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	        #endif
         }
      }
   }
   //защита от самаразморозки в тюрьме
   if(PlayerInfo[playerid][Jailed]){
      TogglePlayerControllable(playerid, 0);
	  return 1;
   }
   //система -хп над игроком
   /*new oldhealth=floatround(health,floatround_floor);
   new newhealth;
   if(oldhealth<100 && !newhealth){
      nh=100-oldhealth;
      newhealth=oldhealth;
      format(str,sizeof(str),"-%d",nh);
      PlayerInfo[playerid][MinusHealth] = Create3DTextLabel(str,COLOR_LIGHTBLUE,30.0,40.0,50.0,40.0,0);
   }
   if(newhealth){
      nh=newhealth-oldhealth
      newhealth=oldhealth;
      format(str,sizeof(str),"-%d",nh);
      PlayerInfo[playerid][MinusHealth] = Create3DTextLabel(str,COLOR_LIGHTBLUE,30.0,40.0,50.0,40.0,0);
   }*/
   return 1;
}

public OnPlayerToPlayerDistance(playerid){
   new Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2;
   for(new i=0;i<MAX_PLAYERS;i++){
	   if(i!=playerid){
		  GetPlayerPos(playerid,x1,y1,z1);
		  GetPlayerPos(i,x2,y2,z2);
	      new distance = floatround(floatsqroot(floatpower(x2-x1,2)+floatpower(y2-y1,2)+floatpower(z2-z1,2)),floatround_floor);
	      if (distance <= 50){
		     glegalkill=1;
		  }
          else glegalkill=0;
       }
   }
   return glegalkill;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new str[900];
	if (PRESSED(KEY_FIRE | KEY_CROUCH))
	{
	   if(IsPlayerInAnyVehicle(playerid)) return 0;
	   new weapons; weapons=GetPlayerWeapon(playerid);
	   //if(glegalkill==1){
	      if(weapons==24 || weapons==25){
		     if(PressedC[playerid] < MaxPresedC){
		        PressedC[playerid]++;
		        if(!IsPlayerAdmin(playerid) || PlayerInfo[playerid][Admin]<1){
	               format(str,sizeof(str),"Игрок %s (id: %d) юзанул баг +С и был заморожен",PlayerInfo[playerid][Name],playerid);
	               WriteEcho(str,INVALID_PLAYER_ID,ConnectMsgColor);
	               #if defined IrcOnOff
	                  format(str,sizeof(str),"14 *** Игрок %s (id: %d) юзанул баг +С и был заморожен",PlayerInfo[playerid][Name],playerid);
	                  IRC_GroupSay(gGroupID, IRC_CHANNEL,str);
	               #endif
	            }
	            else {
			       WriteEcho("Харе +С юзать чем ты лучше остальных?",playerid,ErrorMsgColor);
	            }
	            TogglePlayerControllable(playerid,0);
	            SetTimerEx("TogglePlayerControlT",3000,0,"i",playerid);
	         }
	         else {
			    if(!IsPlayerAdmin(playerid) || !PlayerInfo[playerid][Admin]){
                   format(str,sizeof(str),"Игрок \"%s (id: %d)\" игрок приговорен к 10 минутам заключения за использование бага +С.",PlayerInfo[playerid][Name],playerid);
		           WriteEcho(str,INVALID_PLAYER_ID,MuteMsgColor);
		           #if defined IrcOnOff
		              format(str,sizeof(str),"04 Игрок \"%s (id: %d)\" приговорен к 10 минутам заключения за использование бага +С.",PlayerInfo[playerid][Name],playerid);
	                  IRC_GroupSay(gGroupID, IRC_CHANNEL,str);
	               #endif
	               PlayerInfo[playerid][Jailed] = true; SetPlayerInterior(playerid,3); SetPlayerPos(playerid,197.6661,173.8179,1003.0234); SetPlayerFacingAngle(playerid,0);
	               PlayerInfo[playerid][Jailed] = 10;
	               ResetPlayerWeapons(playerid);
	               PlayerInfo[playerid][JailedTime] = SetTimerEx("UnJailedPlayerT",10*60000,0,"i",playerid);
	               PressedC[playerid]=0;
				   TogglePlayerControllable(playerid, 0);
	            }
	         }
	      }
	   //}
	}
	if (PRESSED(KEY_SUBMISSION | KEY_WALK)){
       if(!PlayerInfo[playerid][Logged]){ WriteEcho("Чтобы использовать эту команду необходимо залогинеться.",playerid,ErrorMsgColor); WriteEcho("",playerid,-1,2,1,"Вход","Введите свой пароль:","Войти","Отмена");}
       else{
	      AllPlayerMenu("usermenu",playerid);
	   }
	}
	if (PRESSED(KEY_SECONDARY_ATTACK)){
       if(PlayerInfo[playerid][AFK]){
	      PlayerInfo[playerid][AFK] = 0;
          Delete3DTextLabel(PlayerInfo[playerid][AFKMsg]);
          SetPlayerColor(playerid,PlayerInfo[playerid][NikColor]);
          format(str, sizeof(str), " *** %s вернулся.",PlayerInfo[playerid][Name]);
	      SendClientMessageToAll(COLOR_LIGHTBLUE, str);
	      #if defined IrcOnOff
	         format(str,sizeof(str),"11 *** %s вернулся.",PlayerInfo[playerid][Name]);
	         IRC_GroupSay(gGroupID, IRC_CHANNEL,str);
	      #endif
	      format(str,sizeof(str),"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~r~%s ~w~is afk.",PlayerInfo[playerid][Name]);
	      GameTextForAll(str,3000,3);
	      TogglePlayerControllable(playerid, 1);
	      return 1;
	   }
       else{
		  return 1;
	   }
	}
	return 1;
}


public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(playerid==clickedplayerid){
       if(!PlayerInfo[playerid][Logged]){ WriteEcho("Чтобы использовать эту команду необходимо залогинеться.",playerid,ErrorMsgColor); WriteEcho("",playerid,-1,2,1,"Вход","Введите свой пароль:","Войти","Отмена");}
       else{
	      AllPlayerMenu("usermenu",playerid);
	      return 1;
	   }
	}
	if(playerid!=clickedplayerid){
       new str1[MAX_STRING],list[900];
       if(!PlayerInfo[playerid][Logged]){ WriteEcho("Чтобы использовать эту возможность необходимо залогинеться.",playerid,ErrorMsgColor); WriteEcho("",playerid,-1,2,1,"Вход","Введите свой пароль","Войти","Отмена");}
       else{
	      format(list,sizeof(list),"Приветствовать\nПопрощаться\nНаписать ПМ\nПередать денег\nВызвать на дуэль\nПожаловаться (игрок читер)");
	      if(PlayerInfo[playerid][Admin]>0) format(list,sizeof(list),"%s\n----------------------------------------",list);
	      if(PlayerInfo[playerid][Admin]>0 && PlayerInfo[playerid][Admin]>PlayerInfo[clickedplayerid][Admin]) format(list,sizeof(list),"%s\nТюрьма (посадить/выпустить)\nЧат (наказать/простить)",list);
	      if(PlayerInfo[playerid][Admin]>1 && PlayerInfo[playerid][Admin]>PlayerInfo[clickedplayerid][Admin]) format(list,sizeof(list),"%s\nДвижение (заморозить/разморозить)\nОбезоружить",list);
	      if(PlayerInfo[playerid][Admin]>2 && PlayerInfo[clickedplayerid][Admin]<PlayerInfo[playerid][Admin]) format(list,sizeof(list),"%s\nВыгнать",list);
	      if(PlayerInfo[playerid][Admin]>2 && PlayerInfo[clickedplayerid][Admin]<=0) format(list,sizeof(list),"%s\nЗабанить",list);
	      if(PlayerInfo[playerid][Admin]>3 && PlayerInfo[clickedplayerid][Admin]<PlayerInfo[playerid][Admin]) format(list,sizeof(list),"%s\nВыкинуть из транспорта",list);
	      if(PlayerInfo[playerid][Admin]>4) format(list,sizeof(list),"%s\nПереместить",list);
	      if(PlayerInfo[playerid][Admin]>5) format(list,sizeof(list),"%s\nПереместиться к игроку",list);
	      if(PlayerInfo[playerid][Admin]>6) format(list,sizeof(list),"%s\nПереместить к себе",list);
	      if(PlayerInfo[playerid][Admin]>7 && PlayerInfo[clickedplayerid][Admin]<PlayerInfo[playerid][Admin]) format(list,sizeof(list),"%s\nКазнить",list);
	      if(PlayerInfo[playerid][Admin]>8) format(list,sizeof(list),"%s\nВылечить",list);
	      if(PlayerInfo[playerid][Admin]>9 && PlayerInfo[clickedplayerid][Admin]>0) format(list,sizeof(list),"%s\nСделать неязвимым",list);
	      if(PlayerInfo[playerid][Admin]>9) format(list,sizeof(list),"%s\nСделать админом",list);
	      if(PlayerInfo[playerid][Admin]>10) format(list,sizeof(list),"%s\nВзорвать",list);
	      format(str1,sizeof(str1),"Действие с %s (id: %d):",PlayerInfo[clickedplayerid][Name],clickedplayerid);
	      WriteEcho("",playerid,-1,4,5,str1,list,"Принять","Отмена");
	      PlayerInfo[playerid][TargetID]=clickedplayerid;
	   }
	}
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid){
    #if defined HousesOnOff
	new i;
    for (i=1;i<=houses_load;i++){
    if (pic_in[i]==pickupid){ // Переход в дом
    if (!houses[i][locked_h]||(strcmp(PlayerInfo[playerid][Name],houses[i][user_h], true) == 0)){
	new tmp[200];
	format(tmp,sizeof(tmp),"Вы вошли в дом, адрес ул.Административная, дом №,%d",i);
	SendClientMessage(playerid, 0x00FF00AA,tmp);
	SetPlayerInterior(playerid, houses[i][inter_h]);
	SetPlayerPos(playerid,houses[i][X_h_out],houses[i][Y_h_out],houses[i][Z_h_out]);
	SetPlayerVirtualWorld(playerid,i);
	destroy_houses_pickup(5,i);
    }
	else
	{
	new tmp[200];
	format(tmp,sizeof(tmp),"Дом заперт, адрес ул.Административная, дом №,%d",i);
	SendClientMessage(playerid, ErrorMsgColor,tmp);
	}
    return;
    }
    if (pic_out[i]==pickupid){// Выйти из дома.
	destroy_houses_pickup(5,i);
    SetPlayerInterior(playerid, 0);
	SetPlayerPos(playerid,houses[i][X_h_in],houses[i][Y_h_in],houses[i][Z_h_in]);
	SetPlayerVirtualWorld(playerid,0);

    return;
    }
    if (pic_spawn[i]==pickupid){
    new tmp[200];
	format(tmp,sizeof(tmp),"Вы воскресли в доме, адрес ул.Административная, дом №,%d",i);
	SendClientMessage(playerid, 0x00FF00AA,tmp);
    return;
    }
    }


	for (new a=0;a<picups;a++){
	if (pickupid == pick[a]){
	if (picaps[a][weapon_p]<=0){ // Если не оружие
	if (picaps[a][weapon_p]==0){
	GiveMoney(playerid,picaps[a][patron_p]);
	if (strlen(picaps[a][text_p])>2){
		SendClientMessage(playerid, HelpMsgColor,picaps[a][text_p]);
	}
	}
	else if (picaps[a][weapon_p]==-1){
	new tmp[MAX_STRING];
	if (strlen(picaps[a][text_p])>2){
	if (strcmp(PlayerInfo[playerid][Name],picaps[a][text_p], true) == 0){
	format(tmp,sizeof(tmp),"Добро пожаловать домой, %s",picaps[a][text_p]);
	SendClientMessage(playerid, 0x00FF00AA,tmp);
	}
	else
	{
    format(tmp,sizeof(tmp),"Владелец: %s",picaps[a][text_p]);
    SendClientMessage(playerid, MuteMsgColor,tmp);
    }
	}
	else
	{
	format(tmp,sizeof(tmp),"Владелец не определен");
	SendClientMessage(playerid, ErrorMsgColor,tmp);
	}

	}
	else if (picaps[a][weapon_p]==-2){
	SendClientMessage(playerid, HelpMsgColor,"Данный дом свободен. Напиши [JRU]S_S или [JRU]kroks_rus, чтобы вселиться");
	}
	}
	else
	{
	GivePlayerWeapon(playerid,picaps[a][weapon_p],picaps[a][patron_p]);
	if (strlen(picaps[a][text_p])>2){
		SendClientMessage(playerid, HelpMsgColor,picaps[a][text_p]);
	}
	}
	}
	}
	#endif
	return 1;
}


stock PlayerAdminLevel(level){
   new lvl[MAX_STRING];
   if(level==0) format(lvl,sizeof(lvl),"Игрок");
   if(level>0 && level<5) format(lvl,sizeof(lvl),"Смотритель");
   if(level>4 && level<7) format(lvl,sizeof(lvl),"Модератор");
   if(level>6) format(lvl,sizeof(lvl),"Администратор");
   return lvl;
}
stock GetWeaponNameRu(weaponid) {
new weanr[256];
switch (weaponid) {
case 0: weanr = "Кулаки";
case 1: weanr = "Кастет";
case 2: weanr = "Гольф клюшка";
case 3: weanr = "Ментовская дубинка";
case 4: weanr = "Нож";
case 5: weanr = "Бейсбольная бита";
case 6: weanr = "Лопата";
case 7: weanr = "Бильярдный кий";
case 8: weanr = "Катана";
case 9: weanr = "Бензопила";
case 10: weanr = "Фаллоимитатор";
case 11: weanr = "Фаллоимитатор";
case 12: weanr = "Вибратор";
case 13: weanr = "Вибратор";
case 14: weanr = "Букет цветов";
case 15: weanr = "Трость";
case 16: weanr = "Граната";
case 17: weanr = "Слезоточивый газ";
case 18: weanr = "Коктейль молотова";
case 19: weanr = "Нет";
case 20: weanr = "Нет";
case 21: weanr = "Нет";
case 22: weanr = "Пистолет";
case 23: weanr = "Пистолет с глушителем";
case 24: weanr = "Пустынный орел";
case 25: weanr = "Ружье";
case 26: weanr = "Обрез";
case 27: weanr = "Боевое ружье";
case 28: weanr = "Узи";
case 29: weanr = "МП5";
case 30: weanr = "АК-47";
case 31: weanr = "М4";
case 32: weanr = "ТЕК9";
case 33: weanr = "Винтовка";
case 34: weanr = "Снайперская винтовка";
case 35: weanr = "Гранатомет";
case 36: weanr = "Самонаводящийся гранатомет";
case 37: weanr = "Огнемет";
case 38: weanr = "Миниган";
case 39: weanr = "Взрывпакет";
case 40: weanr = "Детонатор";
case 41: weanr = "Балончик краски";
case 42: weanr = "Огнетушитель";
case 43: weanr = "Фотоаппарат";
case 44: weanr = "Нет";
case 45: weanr = "Нет";
case 46: weanr = "Парашют";
default: weanr = "Не существует";
}
return weanr;
}

AllCommandsReturn(cmd[],playerid,targetid,param1=0,param2[]=""){
   #pragma unused param1,param2
   new str[MAX_STRING];
   if (!IsPlayerConnected(targetid)) {//проверка подключен ли игрок к серверу
      format(str,sizeof(str),"Игрок не подключен к серверу (%d)",targetid);
	  WriteEcho(str,playerid,ErrorMsgColor);
	  return 1;
   }
   if(PlayerInfo[playerid][Jailed]){
	  WriteEcho("Вы не можите использовать эту опцию находясь в тюрьме.",playerid,ErrorMsgColor);
	  return 0;
   }
   if(strcmp(cmd,"kick", true) == 0){//кик
      new tmp[MAX_STRING],idx;
	  tmp=strtok(param2,idx);
	  if(!strlen(tmp)){
	     format(str,sizeof(str),"Выгнать %s (id: %d):",PlayerInfo[targetid][Name],targetid);
		 WriteEcho("",playerid,-1,2,19,str,"Нельзя выгнать без причины\nУкажате причину:","Выгнать","Отмена");
		 return 1;
	  }
	  if(targetid==playerid){
	     WriteEcho("Нельзя кикать себя",playerid,ErrorMsgColor);
		 return 1;
	  }
	  format(str,sizeof(str),"%s %s (id: %d) выгнал %s (id: %d) с сервера. Причина: %s",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,param2);
	  WriteToLog(str);
	  #if defined KicksFile
	     WriteToLog(str,KicksFile);
	  #endif
	  #if defined AdminsLog
	     WriteToLog(str,AdminsLog);
	  #endif
	  WriteEcho(str,INVALID_PLAYER_ID,KickMsgColor);
	  #if defined IrcOnOff
	     format(str,sizeof(str),"04%s %s (id: %d) выгнал %s (id: %d) с сервера. Причина: %s",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,param2);
	     IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	  #endif
	  Kick(targetid);
	  return 1;
   }

   if(strcmp(cmd,"ban", true) == 0){//бан
      new tmp[MAX_STRING],idx;
	  tmp = strtok(param2,idx);
	  if (!strlen(tmp)) {
	     format(str,sizeof(str),"Забанить %s (id: %d):",PlayerInfo[targetid][Name],targetid);
		 WriteEcho("",playerid,-1,2,20,str,"Нельзя забанить без причины\nУкажате причину:","Забанить","Отмена");
		 return 1;
	  }
	  format(str,sizeof(str),"%s %s (id: %d) забанил %s (id: %d). Причина: %s",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,param2);
	  WriteToLog(str);
	  #if defined BansLog
	     WriteToLog(str,BansLog);
	  #endif
	  #if defined AdminsLog
	     WriteToLog(str,AdminsLog);
	  #endif
	  WriteEcho(str,INVALID_PLAYER_ID,KickMsgColor);
	  #if defined IrcOnOff
	     format(str,sizeof(str),"04%s \"%s (id: %d)\" забанил \"%s (id: %d)\". Причина: %s",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,param2);
	     IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	  #endif
	  Ban(targetid);
	  return 1;
   }
   if(strcmp(cmd,"mute", true) == 0){//заткнуть
      new tmp[MAX_STRING],idx;
	  tmp = strtok(param2,idx);
	  if (!strlen(tmp)) {
		 format(str,sizeof(str),"Заткнуть %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
		 WriteEcho("",playerid,-1,2,21,str,"Ошибка! Не указанно время.\nВведите время и прничину\n(Пример: 1 мат)","Заткнуть","Отмена");
		 return 1;
	  }
	  if (targetid == playerid) {
		WriteEcho("Нельзя наказывать себя",playerid,ErrorMsgColor);
		return 1;
	  }
	  new duration = strval(tmp);
	  if (duration < 1) {
		 format(str,sizeof(str),"Заткнуть %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
		 WriteEcho("",playerid,-1,2,21,str,"Ошибка! Время не может быть меньше 1\nВведите время и прничину\n(Пример: 1 мат)","Заткнуть","Отмена");
		 return 1;
	  }
	  new tmp2[MAX_STRING];
	  tmp2 = strtok(param2,idx);
	  if (!strlen(tmp2)) {
		 format(str,sizeof(str),"Заткнуть %s (id: %d):",PlayerInfo[PlayerInfo[playerid][TargetID]][Name],PlayerInfo[playerid][TargetID]);
		 WriteEcho("",playerid,-1,2,21,str,"Ошибка! Не указана причина.\nВведите время и прничину\n(Пример: 1 мат)","Заткнуть","Отмена");
		 return 1;
	  }
	  format(str,sizeof(str),"%s \"%s (id: %d)\" наказал \"%s (id: %d)\" на %d мин. Причина: %s",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,duration,param2[1]);
	  WriteToLog(str);
	  #if defined MutesLog
	   	 WriteToLog(str,MutesLog);
	  #endif
	  #if defined AdminsLog
	   	 WriteToLog(str,AdminsLog);
	  #endif
	  WriteEcho(str,INVALID_PLAYER_ID,MuteMsgColor);
	  #if defined IrcOnOff
	     format(str,sizeof(str),"04%s \"%s (id: %d)\" наказал \"%s (id: %d)\" на %d мин. Причина: %s",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,duration,tmp2);
         IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	  #endif
	  PlayerInfo[targetid][Mute] = duration;
	  PlayerInfo[targetid][MuteTimer] = SetTimerEx("UnMutePlayerT",duration*60000,0,"i",targetid);
	  return 1;
   }
   if(strcmp(cmd,"unmute", true) == 0){//прастить
	  format(str,sizeof(str),"%s %s (id: %d) прастил %s (id: %d)",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	  WriteToLog(str);
	  #if defined MutesLog
	   	 WriteToLog(str,MutesLog);
	  #endif
	  #if defined AdminsLog
  	     WriteToLog(str,AdminsLog);
	  #endif
	  WriteEcho(str,INVALID_PLAYER_ID,MuteMsgColor);
	  #if defined IrcOnOff
	     format(str,sizeof(str),"04%s %s (id: %d) прастил %s (id: %d)",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	     IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	  #endif
	  PlayerInfo[targetid][Mute] = 0;
	  KillTimer(PlayerInfo[targetid][MuteTimer]);
	  return 1;
   }
   if(PlayerInfo[targetid][Jailed]){
	  WriteEcho("Данное действие не допустимо. Причина: игрок находиться в тюрьме.",playerid,ErrorMsgColor);
	  return 0;
   }
   if(strcmp(cmd,"acolor", true) == 0){//цвет админа
      if (!PlayerInfo[playerid][AdminColored]) {
		PlayerInfo[playerid][AdminColored] = true;
		SetPlayerColor(playerid,AdminColor);
		WriteEcho("Вы установили себе спец. цвет админа.",playerid);
	  }
	  else {
		PlayerInfo[playerid][AdminColored] = false;
		#if defined Teams
			if (PlayerInfo[playerid][Team] > -1) SetPlayerColor(playerid,TeamInfo[PlayerInfo[playerid][Team]][TeamColor]);
			else
		#endif
		SetPlayerColor(playerid,DefaultPlayerColors[playerid]);
		WriteEcho("Вы отключили спец цвет",playerid);
	  }
	  return 1;
   }
   if(strcmp(cmd,"say", true) == 0){//сказать
      new tmp[MAX_STRING],idx;
	  tmp = strtok(param2,idx);
	  if (!strlen(tmp)) {
		 WriteEcho("",playerid,-1,2,23,"Сказать","Введите текст:","Сказать","Отмена");
		 return 1;
	  }
	  format(str,sizeof(str),"%s (id %d) say: %s",PlayerInfo[playerid][Name],playerid,param2);
	  WriteToLog(str);
	  #if defined AdminsLog
	    WriteToLog(str,AdminsLog);
	  #endif
	  format(str,sizeof(str),"* Админ %s: %s",PlayerInfo[playerid][Name],param2);
	  SendClientMessageToAll(AdminSayColor,str);
	  #if defined IrcOnOff
	     format(str,sizeof(str),"10* Админ %s: %s",PlayerInfo[playerid][Name],param2);
	     IRC_GroupSay(gGroupID, IRC_CHANNEL,str);
	  #endif
	  return 1;
   }
   if(strcmp(cmd,"announce", true) == 0){//объявить
      new tmp[MAX_STRING],idx;
	  tmp = strtok(param2,idx);
	  if (!strlen(tmp)) {
		 WriteEcho("",playerid,-1,2,24,"Меню админа. Объявить:","Введите время и текст\nПример: 1 privet","Объявить","Отмена");
		 return 1;
	  }
	  new duration = strval(tmp);
	  if (duration < 1) {
		WriteEcho("",playerid,-1,2,24,"Меню админа. Объявить:","Ошибка. Время не может быть меньше 1\nВведите время и текст\nПример: 1 privet","Объявить","Отмена");
		return 1;
	  }
	  new tmp2[MAX_STRING];
	  strmid(tmp2,param2,strlen(tmp)+1,strlen(param2));
	  if (!strlen(tmp2)) {
		WriteEcho("",playerid,-1,2,24,"Меню админа. Объявить:","Ошибка. Вы не указали текст\nВведите время и текст\nПример: 1 privet","Объявить","Отмена");
		return 1;
	  }
	  GameTextForAll(tmp2,duration*1000,5);
	  format(str,sizeof(str),"%s (id: %d) создал объявление на %d секунд: %s",PlayerInfo[playerid][Name],playerid,duration,tmp2);
	  WriteToLog(str);
	  #if defined AdminsLog
		 WriteToLog(str,AdminsLog);
	  #endif
	  for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	  return 1;
   }
   if(strcmp(cmd,"tocar", true) == 0){//тп к авто
      new tmp[MAX_STRING],idx;
	  tmp = strtok(param2,idx);
	  if (!strlen(tmp)) {
		 WriteEcho("",playerid,-1,2,25,"Меню админа. ТП к транспорту","Укажите id транспорта\nПример: 1","ТП","Отмена");
		 return 1;
	  }
	  new vehicleid = strval(tmp);
	  if (vehicleid < 1 || Vehicles < vehicleid) {
		 format(str,sizeof(str),"Нельзя телепортироватся к этой машине (%d)",vehicleid);
		 WriteEcho(str,playerid,ErrorMsgColor);
		 WriteEcho("",playerid,-1,2,25,"Меню админа. ТП к транспорту","Укажите id транспорта\nПример: 1","ТП","Отмена");
		 return 1;
	  }
	  new Float:x,Float:y,Float:z;
	  GetVehiclePos(vehicleid,x,y,z);
	  if (!IsPlayerInAnyVehicle(playerid)) {
	     SetPlayerInterior(playerid,0);
	     SetPlayerVirtualWorld(playerid,0);
		 SetPlayerPos(playerid,x+3,y+3,z);
	  }
	  else SetVehiclePos(GetPlayerVehicleID(playerid),x+3,y+3,z);
	  format(str,sizeof(str),"%s (id: %d) teleported to vehicle (id: %d)",PlayerInfo[playerid][Name],playerid,vehicleid);
	  WriteToLog(str);
	  #if defined AdminsLog
		 WriteToLog(str,AdminsLog);
	  #endif
	  for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	  format(str,sizeof(str),"Вы переместились к авто (id: %d)",vehicleid);
	  WriteEcho(str,playerid);
	  return 1;
   }
   if(strcmp(cmd,"heall", true) == 0){//Читать ПМ'ы
      if (!PlayerInfo[playerid][HearAll]) {
		 PlayerInfo[playerid][HearAll] = true;
		 WriteEcho("Вы теперь можите видеть ПМ'ы других игроков.",playerid);
	  }
	  else {
		 PlayerInfo[playerid][HearAll] = false;
		 WriteEcho("Вы больше не будите видеть ПМ'ы других игроков.",playerid);
	  }
	  return 1;
   }
   if(strcmp(cmd,"settime", true) == 0){//установить время
      new tmp[MAX_STRING],idx;
	  tmp = strtok(param2,idx);
	  if (!strlen(tmp)) {
		 WriteEcho("",playerid,-1,2,26,"Меню админа. Установить время","Укажите время от 0 до 24:","Установить","Отмена");
		 return 1;
	  }
	  new worldtime = strval(tmp);
	  if (worldtime < 0 || 24 <= worldtime) {
		 format(str,sizeof(str),"Нельзя установить такое время (%d)",worldtime);
		 WriteEcho(str,playerid,ErrorMsgColor);
		 WriteEcho("",playerid,-1,2,26,"Меню админа. Установить время","Укажите время от 0 до 24:","Установить","Отмена");
		 return 1;
	  }
	  #if defined TimeCycle
		 WorldTime = worldtime;
	  #endif
	  SetWorldTime(worldtime);
	  format(str,sizeof(str),"%s (id %d) changed time to %d:00",PlayerInfo[playerid][Name],playerid,worldtime);
	  WriteToLog(str);
	  #if defined AdminsLog
	   	 WriteToLog(str,AdminsLog);
	  #endif
	  for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	  format(str,sizeof(str),"Ты установил игровое время %d:00",worldtime);
	  WriteEcho(str,playerid);
	  return 1;
   }
   if(strcmp(cmd,"globalsave", true) == 0){//сохранение (меню админа)
	  format(str,sizeof(str),"%s (id %d) запустил глобальное сохранение",PlayerInfo[playerid][Name],playerid);
	  WriteToLog(str);
	  #if defined AdminsLog
	   	 WriteToLog(str,AdminsLog);
	  #endif
	  for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	  SaveAllPlayers();
	  WriteEcho("Глобальное сохронение завершено",playerid);
	  return 1;
   }
   if(strcmp(cmd,"gamemodeexit", true) == 0){//перезапуск мода (меню админа)
	  format(str,sizeof(str),"%s (id %d) перезапустил мод",PlayerInfo[playerid][Name],playerid);
	  WriteToLog(str);
	  #if defined AdminsLog
	   	 WriteToLog(str,AdminsLog);
	  #endif
	  for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	  WriteEcho("Перезапуск игрового мода...",playerid);
	  GameModeExit();
	  return 1;
   }
   if(!PlayerInfo[targetid][Spawn]){
	  format(str,sizeof(str),"Игрок %s (id: %d) еще не заспавнился.",PlayerInfo[targetid][Name],targetid);
	  WriteEcho(str,playerid,ErrorMsgColor);
	  return 0;
   }
   if(PlayerInfo[targetid][AFK]){
	  format(str,sizeof(str),"Игрок %s (id: %d) временно отсутствует на сервере (AFK).",PlayerInfo[targetid][Name],targetid);
	  WriteEcho(str,playerid,ErrorMsgColor);
	  return 0;
   }
   if(strcmp(cmd,"freeze", true) == 0){//заморозка
      if(!PlayerInfo[targetid][Freeze]){
	     if (targetid == playerid) {
            WriteEcho("Нельзя заморозить себя.",playerid,ErrorMsgColor);
            return 1;
	     }
	     if(!IsPlayerConnected(targetid)) {
		    format(str,sizeof(str),"Нельзя замораживать несуществующих игроков (%d)",targetid);
		    WriteEcho(str,playerid,ErrorMsgColor);
		    return 1;
	     }
	     if(IsPlayerAdmin(targetid) || PlayerInfo[targetid][Admin] >= PlayerInfo[playerid][Admin]) {
		    format(str,sizeof(str),"Ты не можешь заморозить %s (id: %d), так как он(а) %s ()",PlayerInfo[targetid][Name],targetid,PlayerAdminLevel(PlayerInfo[targetid][Admin]),PlayerInfo[targetid][Admin]);
		    WriteEcho(str,playerid,ErrorMsgColor);
		    return 1;
	     }
	     TogglePlayerControllable(targetid,0);
	     PlayerInfo[targetid][Freeze]=1;
	     format(str,sizeof(str),"%s %s (id: %d) заморозил %s (id: %d)",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	     WriteToLog(str);
	     #if defined AdminsLog
	   	    WriteToLog(str,AdminsLog);
	     #endif
	     WriteEcho(str,INVALID_PLAYER_ID,FreezeMsgColor);
	     #if defined IrcOnOff
	        format(str,sizeof(str),"04%s %s (id: %d) заморозил %s (id: %d)",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
            IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	     #endif
	     return 1;
	  }
	  else {
	     TogglePlayerControllable(targetid,1);
	     PlayerInfo[targetid][Freeze]=0;
	     format(str,sizeof(str),"%s %s (id: %d) разморозил %s (id: %d)",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	     WriteToLog(str);
	     #if defined AdminsLog
	   	    WriteToLog(str,AdminsLog);
	     #endif
	     WriteEcho(str,INVALID_PLAYER_ID,FreezeMsgColor);
	     #if defined IrcOnOff
	        format(str,sizeof(str),"04%s %s (id: %d) разморозил %s (id: %d)",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	        IRC_GroupSay(gGroupID,IRC_CHANNEL,str);
	     #endif
	     return 1;
	  }
   }
   if(strcmp(cmd,"disarm", true) == 0){//отобрать оружие
      if (IsPlayerAdmin(targetid) || PlayerInfo[targetid][Admin] >= PlayerInfo[playerid][Admin]) {
	     format(str,sizeof(str),"Ты не можешь забрать оружие у администратора (%s (id: %d))",PlayerInfo[targetid][Name],targetid);
	     WriteEcho(str,playerid,ErrorMsgColor);
		 return 1;
	  }
	  ResetPlayerWeapons(targetid);
	  format(str,sizeof(str),"%s (id: %d) disarmed %s (id: %d)",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	  WriteToLog(str);
	  #if defined AdminsLog
	     WriteToLog(str,AdminsLog);
	  #endif
	  for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid && i != targetid) WriteEcho(str,i,AdminChatColor);
	  format(str,sizeof(str),"Ты забрал оружие у %s (id: %d)",PlayerInfo[targetid][Name],targetid);
	  WriteEcho(str,playerid);
	  format(str,sizeof(str),"%s %s (id: %d) забпал(а) у вас оружие",PlayerAdminLevel(PlayerInfo[playerid][Admin]),PlayerInfo[playerid][Name],playerid);
	  WriteEcho(str,targetid);
	  return 1;
   }
   if(strcmp(cmd,"teleport", true) == 0){//переместить
      if(!IsPlayerInAnyVehicle(targetid)) {
	     SetPlayerInterior(targetid,0);
		 SetPlayerPos(targetid,LocationInfo[gPlayerSelect][LocationX],LocationInfo[gPlayerSelect][LocationY],LocationInfo[gPlayerSelect][LocationZ]);
	  }
	  if(IsPlayerInAnyVehicle(targetid)){
	     SetVehiclePos(GetPlayerVehicleID(targetid),LocationInfo[gPlayerSelect][LocationX],LocationInfo[gPlayerSelect][LocationY],LocationInfo[gPlayerSelect][LocationZ]);
	  }
	  if(targetid==playerid){
         format(str,sizeof(str),"%s (id: %d) переместился сюда: %s",PlayerInfo[playerid][Name],playerid,LocationInfo[gPlayerSelect][LocationName]);
	     WriteToLog(str);
	     #if defined AdminsLog
	        WriteToLog(str,AdminsLog);
	     #endif
	     for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	     format(str,sizeof(str),"Вы переместились сюда: %s",LocationInfo[gPlayerSelect][LocationName]);
	     WriteEcho(str,playerid);
	     return 1;
	  }
	  else {
	     format(str,sizeof(str),"%s (id: %d) переместил игрока %s (id: %d) сюда: %s(%d)",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid,LocationInfo[gPlayerSelect][LocationName],gPlayerSelect);
	     WriteToLog(str);
	     #if defined AdminsLog
	        WriteToLog(str,AdminsLog);
	     #endif
	     for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	     format(str,sizeof(str),"Ты переместил(а) %s (id: %d) сюда: %s",PlayerInfo[targetid][Name],targetid,LocationInfo[gPlayerSelect][LocationName]);
	     WriteEcho(str,playerid);
	     return 1;
	  }
   }
   if(strcmp(cmd,"gethere", true) == 0){//тп к себе
      if(targetid == playerid) {
	     WriteEcho("Нельзя телепортировать себя к себе",playerid,ErrorMsgColor);
		 return 0;
	  }
	  new Float:x,Float:y,Float:z;
	  GetPlayerPos(playerid,x,y,z);
	  if (!IsPlayerInAnyVehicle(targetid)) {
	     SetPlayerInterior(targetid,GetPlayerInterior(playerid));
	     SetPlayerVirtualWorld(targetid,GetPlayerVirtualWorld(playerid));
		 SetPlayerPos(targetid,x,y-5.0000,z);
      }
	  else SetVehiclePos(GetPlayerVehicleID(targetid),x,y-5.0000,z);
	  format(str,sizeof(str),"%s (id: %d) переместил %s (id: %d) к себе",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	  WriteToLog(str);
	  #if defined AdminsLog
	     WriteToLog(str,AdminsLog);
	  #endif
	  for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	  format(str,sizeof(str),"Ты переместил(а) %s (id: %d) к себе",PlayerInfo[targetid][Name],targetid);
	  WriteEcho(str,playerid);
	  return 1;
   }
   if(strcmp(cmd,"goto", true) == 0){//тп к игроку
      new Float:x,Float:y,Float:z;
	  GetPlayerPos(targetid,x,y,z);
	  if (!IsPlayerInAnyVehicle(playerid)) {
	     SetPlayerInterior(playerid,GetPlayerInterior(targetid));
	     SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(targetid));
		 SetPlayerPos(playerid,x,y-5.0000,z);
	  }
	  else SetVehiclePos(GetPlayerVehicleID(playerid),x,y-5.0000,z);
	  format(str,sizeof(str),"%s (id: %d) телепортировался к игроку %s (id: %d)",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	  WriteToLog(str);
	  #if defined AdminsLog
	     WriteToLog(str,AdminsLog);
	  #endif
	  for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	  format(str,sizeof(str),"Ты переместился(ась) к %s (id: %d)",PlayerInfo[targetid][Name],targetid);
	  WriteEcho(str,playerid);
	  return 1;
   }
   if(strcmp(cmd,"rape", true) == 0){//казнить
      if(IsPlayerAdmin(targetid) || PlayerInfo[targetid][Admin] >= PlayerInfo[playerid][Admin]) {
	     format(str,sizeof(str),"Ты не можешь убить админа (%s (id: %d))",PlayerInfo[targetid][Name],targetid);
		 WriteEcho(str,playerid,ErrorMsgColor);
		 return 1;
	  }
	  SetPlayerHealth(targetid,0);
	  format(str,sizeof(str),"%s (id: %d) raped %s (id: %d)",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	  WriteToLog(str);
	  #if defined AdminsLog
	     WriteToLog(str,AdminsLog);
	  #endif
	  for(new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid) WriteEcho(str,i,AdminChatColor);
	  format(str,sizeof(str),"Ты убил %s (id: %d)",PlayerInfo[targetid][Name],targetid);
	  WriteEcho(str,playerid);
	  return 1;
   }
   if(strcmp(cmd,"heal", true) == 0){//лечить
      new Float:health; GetPlayerHealth(targetid,health);
      if(health<100 || health>105){
         SetPlayerHealth(targetid,100);
         if(targetid==playerid){
            format(str,sizeof(str),"%s (id: %d) вылечился",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	        WriteToLog(str);
	        #if defined AdminsLog
	           WriteToLog(str,AdminsLog);
	        #endif
	        for(new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid && i != targetid) WriteEcho(str,i,AdminChatColor);
	        WriteEcho("Вы вылечились",playerid);
	        return 1;
         }
         else {
	        format(str,sizeof(str),"%s (id: %d) healed %s (id: %d)",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	        WriteToLog(str);
	        #if defined AdminsLog
	           WriteToLog(str,AdminsLog);
	        #endif
	        for(new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid && i != targetid) WriteEcho(str,i,AdminChatColor);
	        format(str,sizeof(str),"Ты вылечил(а) %s (id: %d)",PlayerInfo[targetid][Name],targetid);
	        WriteEcho(str,playerid);
	        format(str,sizeof(str),"%s (id: %d) вылечил(а) вас.",PlayerInfo[playerid][Name],playerid);
	        WriteEcho(str,targetid);
	        return 1;
	     }
	  }
	  else {
         if(targetid==playerid){ WriteEcho("Вы здоровы.",playerid,ErrorMsgColor); return 0;}
         else format(str,sizeof(str),"Игрок %s (id: %d) здоров.",PlayerInfo[targetid][Name],targetid); WriteEcho(str,playerid,ErrorMsgColor);
	  }
	  return 1;
   }
   if(strcmp(cmd,"gm", true) == 0){//гм
      SetPlayerHealth(targetid,100000);
	  if(targetid==playerid){
         format(str,sizeof(str),"%s (id: %d) стал бессмертным",PlayerInfo[playerid][Name],playerid);
	     WriteToLog(str);
	     #if defined AdminsLog
	        WriteToLog(str,AdminsLog);
	     #endif
	     for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid && i != targetid) WriteEcho(str,i,AdminChatColor);
	     WriteEcho("Вы теперь бессмерты",playerid);
	  }
      else {
	     format(str,sizeof(str),"%s (id: %d) дал бессмертие %s (id: %d)",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	     WriteToLog(str);
	     #if defined AdminsLog
	        WriteToLog(str,AdminsLog);
	     #endif
	     for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid && i != targetid) WriteEcho(str,i,AdminChatColor);
	     format(str,sizeof(str),"%s (id: %d) стал бессмертным",PlayerInfo[targetid][Name],targetid);
	     WriteEcho(str,playerid);
	     format(str,sizeof(str),"%s (id: %d) сделал вас бессмертным",PlayerInfo[playerid][Name],playerid);
	     WriteEcho(str,targetid);
	  }
	  return 1;
   }
   if(strcmp(cmd,"outcar", true) == 0){//выкинуть из авто
      if(!IsPlayerInAnyVehicle(targetid)){
		 format(str,sizeof(str),"Игрок %s (id: %d) пешеход.",PlayerInfo[targetid][Name],targetid);
         WriteEcho(str,playerid,ErrorMsgColor);
         return 0;
      }
      RemovePlayerFromVehicle(targetid);
	  format(str,sizeof(str),"%s (id: %d) thrown %s (id: %d) from car",PlayerInfo[playerid][Name],playerid,PlayerInfo[targetid][Name],targetid);
	  WriteToLog(str);
	  #if defined AdminsLog
	    WriteToLog(str,AdminsLog);
	  #endif
	  for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0) && i != playerid && i != targetid) WriteEcho(str,i,AdminChatColor);
	  format(str,sizeof(str),"Ты выкинул %s (id: %d) из машины",PlayerInfo[targetid][Name],targetid);
	  WriteEcho(str,playerid);
	  format(str,sizeof(str),"%s (id: %d) выкинул тебя из машины",PlayerInfo[playerid][Name],playerid);
	  WriteEcho(str,targetid);
	  return 1;
   }
   else {
      WriteEcho("Данная опция в разработке",playerid,ErrorMsgColor);
   }
   return 1;
}

AllPlayerMenu(type[],playerid){
   new menu[900];
   if(strcmp(type,"usermenu", true) == 0){
	  if(PlayerInfo[playerid][Admin]){
	     format(menu,sizeof(menu),"Меню админа\nКупить оружие\nПриветствовать всех\nПопращаться со всеми\nСтатистика\nДуэль%s\nПомощь\nПравила\nСменя пароля\nВремя\nТермины\nСохранить позицию ($5000)\nВернуться на позицию ($500)\nНастройки профиля",textDuelInMenu(playerid));
	  }
	  else {
	     format(menu,sizeof(menu),"Купить оружие\nПриветствовать всех\nПопращаться со всеми\nСтатистика\nДуэль%s\nПомощь\nПравила\nСменя пароля\nВремя\nТермины\nСохранить позицию ($5000)\nВернуться на позицию ($500)\nНастройки профиля",textDuelInMenu(playerid));
	  }
	  WriteEcho("",playerid,-1,4,4,"Меню игрока:",menu,"Принять","Отмена");
	  return 1;
   }
   if(strcmp(type,"adminmenu", true) == 0){
      if(PlayerInfo[playerid][Admin]>0) format(menu,sizeof(menu),"Цвет админа");
	  if(PlayerInfo[playerid][Admin]>1) format(menu,sizeof(menu),"%s\nСказать\nОбъявить",menu);
      if(PlayerInfo[playerid][Admin]>3) format(menu,sizeof(menu),"%s\nПереместиться\nПереместиться к авто",menu);
	  if(PlayerInfo[playerid][Admin]>6) format(menu,sizeof(menu),"%s\nУстановит время\nЧитать ПМ'мы",menu);
	  if(PlayerInfo[playerid][Admin]>7) format(menu,sizeof(menu),"%s\nВыличиться\nБессмертие",menu);
	  if(PlayerInfo[playerid][Admin]>9) format(menu,sizeof(menu),"%s\nСохранение\nПерезапуск мода\nНастройки мода",menu);
	  WriteEcho("",playerid,-1,4,6,"Меню админа:",menu,"Принять","Отмена");
	  return 1;
   }
   if(strcmp(type,"GameModeOptions", true) == 0){
	  WriteEcho("",playerid,-1,4,6,"Настройки мода:","Автовход (Откл)\nСообщение +С (Вкл)\nАнтичит (Вкл)\nОбъявления (Откл)","Сохранить","Отмена");
	  return 1;
   }
   if(strcmp(type,"UserProfelOptions", true) == 0){
	  format(menu,sizeof(menu),"Анкета\nАвтовход (%s)\nВсплывающие ПМ (%s)\n",GetOnOff(PlayerInfo[playerid][LogginType]),GetOnOff(PlayerInfo[playerid][PMType],1));
	  WriteEcho("",playerid,-1,4,27,"Настройки проофиля:",menu,"Изменить","Закрыть");
	  return 1;
   }
   if(strcmp(type,"teleportmenu", true) == 0){
      for(new i=0; i<Locations;i++){
		 format(menu,sizeof(menu),"%s\n%s",menu,LocationInfo[i][LocationName]);
	  }
	  WriteEcho("",playerid,-1,4,18,"ТП. Выберети место назначения:",menu,"ТП","Отмена");
	  return 1;
   }
   if(strcmp(type,"buygan", true) == 0){
      for(new i=0;i<Weapons;i++){
			   format(menu,sizeof(menu),"%s\n%s ($%d)",menu,GetWeaponNameRu(WeaponInfo[i][WeaponID]),WeaponInfo[i][WeaponCost]);
	  }
	  WriteEcho("",playerid,-1,4,7,"Покупка оружия:",menu,"Купить","Отмена");
	  return 1;
   }
   return 1;
}
GetOnOff(value,types=0){
   new returntype[20];
   if(types==1){
	  if(value==1){
	     format(returntype,sizeof(returntype),"Откл");
      }
      else {
         format(returntype,sizeof(returntype),"Вкл");
      }
   }
   else {
      if(value==1){
	     format(returntype,sizeof(returntype),"Вкл");
      }
      else {
         format(returntype,sizeof(returntype),"Откл");
      }
   }
   return returntype;
}

/* IRC */
#if defined IrcOnOff
public IRC_OnConnect(botid)
{
	printf("*** IRC: Бот №%d подключился", botid);
	IRC_JoinChannel(botid, IRC_CHANNEL);
	IRC_AddToGroup(gGroupID, botid);
	return 1;
}
public IRC_OnDisconnect(botid)
{
	printf("*** IRC_OnDisconnect: Bot ID %d disconnected!", botid);
	if (botid == gBotID[0])
	{

		SetTimerEx("IRC_ConnectDelay", 10000, 0, "d", 1);
	}
	printf("*** IRC_OnDisconnect: Bot ID %d attempting to reconnect...", botid);
	// Remove the bot from the group
	IRC_RemoveFromGroup(gGroupID, botid);
	return 1;
}
public IRC_OnJoinChannel(botid, channel[])
{
	printf("*** IRC_OnJoinChannel: Bot ID %d joined channel %s!", botid, channel);
	return 1;
}



public IRC_OnUserDisconnect(botid, user[], host[], message[])
{
	new mesage[256];
	format(mesage, sizeof(mesage), "IRC %s отключился ", user, message);
	SendClientMessageToAll(0xDEEE20FF, mesage);
	return 1;
}

public IRC_OnUserJoinChannel(botid, channel[], user[], host[])
{
	new mesage[256];
	format(mesage, sizeof(mesage), "IRC %s присоеденился к чату", user);
	SendClientMessageToAll(0xDEEE20FF, mesage);
	return 1;
}

public IRC_OnUserLeaveChannel(botid, channel[], user[], host[], message[])
{

	new mesage[256];
	format(mesage, sizeof(mesage), "IRC %s покинул чат ", user, message);
	SendClientMessageToAll(0xDEEE20FF, mesage);

	return 1;
}

public IRC_OnUserNickChange(botid, oldnick[], newnick[], host[])
{
	new mesage[256];
	format(mesage, sizeof(mesage), "IRC \"%s\" поменял ник на \"%s\" ", oldnick, newnick);
	SendClientMessageToAll(0xDEEE20FF, mesage);
	return 1;
}

public IRC_OnUserSetChannelMode(botid, channel[], user[], host[], mode[])
{
	// printf("*** IRC_OnUserSetChannelMode (Bot ID %d): User %s (%s) on %s set mode: %s!", botid, user, host, channel, mode);
	return 1;
}

public IRC_OnUserSetChannelTopic(botid, channel[], user[], host[], topic[])
{
	// printf("*** IRC_OnUserSetChannelTopic (Bot ID %d): User %s (%s) on %s set topic: %s!", botid, user, host, channel, topic);
	return 1;
}
getstrings(text[],cmmd[],cmd[]){
	new from;
	from=strlen(cmmd)+strlen(gIRC_pass)+strlen(cmd)+4;
	new sending[MAX_STRING],y;
	y=0;
	for (new i=from;i<strlen(text);i++)
	{
	sending[y]=text[i];
	y++;
	}
	return sending;

}
getstr_pos(text[],pos){
    new sending[MAX_STRING],y;
	y=0;
	for (new i=pos;i<strlen(text);i++)
	{
	sending[y]=text[i];
	y++;
	}
	return sending;
}
public IRC_OnUserSay(botid, recipient[], user[], host[], message[]){
   if(!strcmp(recipient, BOT_1_NICKNAME)){
      new index,cmd[300];
	  cmd = strtok(message, index);
	  if ((strcmp(cmd, "#pm", true) == 0)||(strcmp(cmd, "/pm", true) == 0)||(strcmp(cmd, "пм", true) == 0)){
         new tmp[300],id;
		 tmp = strtok(message, index);
		 if (strlen(tmp)){
		    id = strval(tmp);
			if (IsPlayerConnected(id)){
			   new text[300];
			   text= strtok(message, index);
			   if (strlen(tmp)){
			      IRC_Say(botid, user, "*** Сообщение послано");
			      new gametext[200];
			      format(gametext, sizeof(gametext), "PM (IRC:%s) : %s ", user, message);
			      SendClientMessage(id, PrivateMsgColor, gametext);
			   }
			   else {
			      IRC_Say(botid, user, "*** Введите текст сообщения");
			   }
			}
			else {
			   IRC_Say(botid, user, "*** Игорок не подключен");
			}
	     }
	     else {
	       IRC_Say(botid, user, "*** Введите id игрока");
	     }
	     return 1;
      }
      if((strcmp(cmd, "#admin", true) == 0)||(strcmp(cmd, "/admin", true) == 0)||(strcmp(cmd, "админ", true) == 0)){
         new tmp[300];
	     tmp=strtok(message,index);
	     if (strlen(tmp)&&(strcmp(tmp, gIRC_pass, true) == 0)){
	        new cmmd[300];
		    cmmd= strtok(message, index);
		    if (strlen(cmmd)){
               if ((strcmp(cmmd, "help", true) == 0)||(strcmp(cmmd, "помощь", true) == 0)||(strcmp(cmmd, "cmd", true) == 0)){
			      IRC_Say(botid, user, "*** Список команд ****");
			      new str123[MAX_STRING];
                  format(str123,sizeof(str123),"mode %s +o %s",IRC_CHANNEL,user);
                  IRC_SendRaw(botid,str123);
                  IRC_Say(botid, user, "04 *** Добро пожаловать ****");
			      IRC_Say(botid, user, "Кик : #admin(или админ) <pass> kick (или кик)  <id>");
			      IRC_Say(botid, user, "Бан : #admin(или админ) <pass> ban (или бан)  <id>");
			      IRC_Say(botid, user, "Посадить : #admin(или админ) <pass> jail (или посадить)  <id>  <причина> ** сажает только на 10 минут!");
			      IRC_Say(botid, user, "Отпустить : #admin(или админ) <pass> unjail (или отпустить)  <id> ");
			      IRC_Say(botid, user, "Кляп : #admin(или админ) <pass> mute (или замолчать)  <id> <time> <причина>");
			      IRC_Say(botid, user, "Разрешить говорить : #admin(или админ) <pass> unmute (или говорить)  <id>");
			      IRC_Say(botid, user, "Сказать от админа : #admin(или админ) <pass> say (или сказать)  <text>");
			      IRC_Say(botid, user, "Объявить : #admin(или админ) <pass> announce (или объявление)  <text>");
			      IRC_Say(botid, user, "Время : #admin(или админ) <pass> time (или время)  <time>");
			      IRC_Say(botid, user, "Полная информация об игроке : #admin(или админ) <pass> player (или игрок)  <id>");
			   }
			   if((strcmp(cmmd, "player", true) == 0)||(strcmp(cmmd, "игрок", true) == 0)){
			      new tmps[MAX_STRING],string[MAX_STRING],str[MAX_STRING],id;
			      tmps = strtok(message,index);
			      id=strval(tmps);
			      if(IsPlayerConnected(id)){
			         new Float:health;
    		         GetPlayerHealth(id,health);
			         IRC_Say(botid, user, "*** Информация об игроке ***");
			         format(str,sizeof(str),"статистика (%s):",PlayerInfo[id][Name]);
			         IRC_Say(botid, user, str);
			         new plrIP[16];
    		         GetPlayerIp(id, plrIP, sizeof(plrIP));
			         format(string,sizeof(string),"IP: %s",plrIP);
			         IRC_Say(botid, user, string);
			         format(string,sizeof(string),"Ping: %d",GetPlayerPing(id));
				     IRC_Say(botid, user, string);
			         format(string,sizeof(string),"Health: %f",health);
				     IRC_Say(botid, user, string);
			         format(str,sizeof(str),"Денег: %d",GetPlayerMoney(id));
		             IRC_Say(botid, user, str);
			         format(str,sizeof(str),"Убийств: %d",PlayerInfo[id][Kills]);
	                 IRC_Say(botid, user, str);
			         format(str,sizeof(str),"Максимум убийств за жизнь: %d",PlayerInfo[id][MaxKillsForLife]);
			         IRC_Say(botid, user, str);
			         format(str,sizeof(str),"Смертей: %d",PlayerInfo[id][Deaths]);
			         IRC_Say(botid, user, str);
			         format(str,sizeof(str),"Самоубийств: %d",PlayerInfo[id][Suicides]);
			         IRC_Say(botid, user, str);
			         if (PlayerInfo[id][Deaths] > 0) {
			            new Float:ratio = floatdiv(PlayerInfo[id][Kills],PlayerInfo[id][Deaths]);
			            format(str,sizeof(str),"Соотношение убийство/смерть: %f",ratio);
			            IRC_Say(botid, user, str);
			         }
			      }
			      else {
			         IRC_Say(botid, user, "*** такой ID не подключен, или ты не ввел ID");
			      }
			      return 1;
			   }
			   if((strcmp(cmmd, "jail", true) == 0)||(strcmp(cmmd, "посадить", true) == 0)){//Посадить
                  new tmps[MAX_STRING],string[MAX_STRING],id,strg[MAX_STRING];
			      tmps = strtok(message,index);
			      id=strval(tmps);
			      strg=getstrings(message,cmmd,cmd);
			      if(!strlen(tmps)||!strlen(strg)) {
			         IRC_Say(botid, user, "*** А ID и причину и время кто будет вводить!?");
			         return 1;
			      }
                  new d=strval(strg);
			      if(!IsPlayerConnected(id) || IsPlayerAdmin(id) || PlayerInfo[id][Admin] >0) return 1;
			      format(string,256,"Игрок \"%s (id: %d)\" был приговорен администратором \"%s \" к 10 мин заключения. Причина: %s",PlayerInfo[id][Name],id,user,strg); WriteEcho(string,MuteMsgColor);
	   		      PlayerInfo[id][Jailed] = true; SetPlayerInterior(id,3); SetPlayerPos(id,197.6661,173.8179,1003.0234); SetPlayerFacingAngle(id,0);
	  		      PlayerInfo[id][Jailed] = d;
	  		      TogglePlayerControllable(id, 0);
	 		      ResetPlayerWeapons(id);
	 		      PlayerInfo[id][JailedTime] = SetTimerEx("UnJailedPlayerT",strval(strg)*60000,0,"i",id);

			   }// /Посадить
			   if((strcmp(cmmd, "unjail", true) == 0)||(strcmp(cmmd, "отпустить", true) == 0)){//Отпустить
			      new tmps[MAX_STRING],id;
			      tmps = strtok(message,index);
			      id=strval(tmps);
			      if (!strlen(tmps)) {
			         IRC_Say(botid, user, "*** А ID кто будет вводить!?");
			         return 1;
			      }
			      if (!IsPlayerConnected(id) || !PlayerInfo[id][Jailed]) return 1;
			      new str[256];
			      format(str,sizeof(str),"Игрока \"%s\" освабодил из тюрьмы %s",PlayerInfo[id][Name],user);
			      WriteEcho(str,INVALID_PLAYER_ID,MuteMsgColor);
			      PlayerInfo[id][Jailed] = 0;
			      KillTimer(PlayerInfo[id][JailedTime]);
			      SetPlayerInterior(id,0);
			      SetPlayerPos(id,2343.1265,2457.8074,14.9688);
			      SetPlayerFacingAngle(id,0);
			      TogglePlayerControllable(id, 1);
			   }// /Отпустить
			   if((strcmp(cmmd, "announce", true) == 0)||(strcmp(cmmd, "объявить", true) == 0)){//сказать
			      new ttex[MAX_STRING],str[MAX_STRING];
			      ttex=getstr_pos(message,strlen(cmd)+strlen(cmmd)+strlen(gIRC_pass)+3);
			      GameTextForAll(ttex,5*1000,5);
			      format(str,sizeof(str),"IRC: %s  announced на 5 секунд: %s",user,ttex);
			      IRC_Say(botid, user, "*** Сказали");
			      WriteToLog(str);
			      #if defined AdminsLog
				     WriteToLog(str,AdminsLog);
			      #endif
			      for (new i=0;i<MAX_PLAYERS;i++) if (IsPlayerConnected(i) && (IsPlayerAdmin(i) || PlayerInfo[i][Admin] > 0)) WriteEcho(str,i,AdminChatColor);
			   }// zСказать
			   if((strcmp(cmmd, "kick", true) == 0)||(strcmp(cmmd, "кик", true) == 0)){// kick
			      new tmps[MAX_STRING],id;
			      tmps = strtok(message,index);
			      id=strval(tmps);
			      if(!strlen(tmps)) {
   			         IRC_Say(botid, user, "*** А ID кто будет вводить!?");
			         return 1;
			     }
			     if(!IsPlayerConnected(id) || IsPlayerAdmin(id) || PlayerInfo[id][Admin] >0) return 1;
			     new str[MAX_STRING],reason[300];
			     reason=getstrings(message,cmmd,cmd);
			     format(str,sizeof(str),"Игрок %s (id: %d) кикнут %s. Причина: %s",PlayerInfo[id][Name],id,user,reason);
			     WriteToLog(str);
			     #if defined KicksLog
			        WriteToLog(str,KicksLog);
			     #endif
			     WriteEcho(str,INVALID_PLAYER_ID,KickMsgColor);
			     Kick(id);
			     IRC_Say(botid, user, "*** Кикнул");
			   }// End kick
			   if ((strcmp(cmmd, "time", true) == 0)||(strcmp(cmmd, "время", true) == 0)){
                  new text[300];
			      text= strtok(message, index);
			      if (strlen(text)) {
			         new worldtime = strval(text);
			         if (worldtime < 0 || 24 <= worldtime){
			            IRC_Say(botid, user, "*** Ты ненормальный?");
			         }
			         else {
			            new str[256];
			            format(str,sizeof(str),"IRC: %s установил время  %d:00",user,worldtime);
			            WriteToLog(str);
			            #if defined TimeCycle
			               WorldTime = worldtime;
			            #endif
			            SetWorldTime(worldtime);
			            IRC_Say(botid, user, "*** Установил время");
			         }
			      }
			      else {
			         IRC_Say(botid, user, "*** А время кто будет вводить?");
			      }
			   }
			   if((strcmp(cmmd, "ban", true) == 0)||(strcmp(cmmd, "бан", true) == 0)){// Начало бана
                  new tmps[MAX_STRING],id;
			      tmps = strtok(message,index);
			      id=strval(tmps);
			      if(!strlen(tmps)){
			         IRC_Say(botid, user, "*** А ID кто будет вводить!?");
			         return 1;
			      }
                  if(!IsPlayerConnected(id) || IsPlayerAdmin(id) || PlayerInfo[id][Admin] > 0){
                     IRC_Say(botid, user, "*** Нельзя");
			         return 1;
			      }
			      new strg[MAX_STRING];
			      strg=getstrings(message,cmmd,cmd);
			      new str[MAX_STRING];
			      format(str,sizeof(str),"Игрок %s (id: %d) забанен %s. Причина: %s",PlayerInfo[id][Name],id,user,strg);
			      WriteToLog(str);
			      #if defined BansLog
			         WriteToLog(str,BansLog);
			      #endif
			      WriteEcho(str,INVALID_PLAYER_ID,BanMsgColor);
			      PlayerInfo[id][Bans]=1;
			      Ban(id);
			      IRC_Say(botid, user, "*** Забанил");
			   }// Конец бана
			   if((strcmp(cmmd, "player", true) == 0)||(strcmp(cmmd, "игрок", true) == 0)){
			      return 0;
			   }
			   if((strcmp(cmmd, "say", true) == 0)||(strcmp(cmmd, "сказать", true) == 0)){
 			      new text[300];
			      text= strtok(message, index);
			      new tmps[MAX_STRING];
			      tmps = strtok(message,index);
			      if(!strlen(tmps)) {
			         IRC_Say(botid, user, "*** А текст кто будет вводить!?");
			         return 1;
			      }
			      new str[MAX_STRING],strg[MAX_STRING];
			      strg=getstrings(message,cmmd,cmd);
			      format(str,sizeof(str),"IRC: %s say: %s",user,strg);
			      WriteToLog(str);
			      #if defined AdminsLog
		   	         WriteToLog(str,AdminsLog);
			      #endif
			      format(str,sizeof(str),"**Администратор %s: %s",user,strg);
			      SendClientMessageToAll(AdminSayColor,str);
			      IRC_Say(botid, user,strg);
			   }
		    }
		    else{
		       IRC_Say(botid, user, "*** А команду кто будет вводить?");
		    }
	     }
	     else {
	        IRC_Say(botid, user, "*** Введите Пароль правильно!");
	     }
	     return 1;
      }
      if((strcmp(cmd, "#players", true) == 0)||(strcmp(cmd, "/players", true) == 0)||(strcmp(cmd, "игроки", true) == 0)){
         new send[500],pl;
	     pl=0;
 	     for( new a;a<MAX_PLAYERS;a++){
 	        if(IsPlayerConnected(a)){
 	           new name[MAX_PLAYER_NAME];
 	           GetPlayerName(a, name, sizeof(name));
 	           format(send, sizeof(send), "%s, %s[id:%d] ", send, PlayerInfo[a][Name], a);
 	           pl++;
 	        }
 	     }
 	     if(pl==0){
 	        IRC_Say(botid, user, "Игроков нет!");
 	     }
 	     else IRC_Say(botid, user, send);
	     return 1;
      }
   if((strcmp(cmd, "#help", true) == 0)||(strcmp(cmd, "/help", true) == 0)||(strcmp(cmd, "помощь", true) == 0)){
      IRC_Say(botid, user, "#pm(пм) <playerid> <text>");
 	  IRC_Say(botid, user, "#players(игроки)");
 	  //IRC_Say(botid, user, "Можно использовать \"/\" вместо \"#\"");
	  return 1;
   }
   }
   else {
      if(message[0]=='*'||message[0]=='#'||message[0]=='.'){
         new index,cmd[300];
         cmd = strtok(message, index);
         if((strcmp(cmd, "*me", true) == 0)||(strcmp(cmd, ".me", true) == 0)||(strcmp(cmd, ".я", true) == 0)){
            IRC_Say(botid, user, "Что то хотели ввести?");
         }
         return 1;
      }
      new mesage[MAX_STRING];
      format(mesage, sizeof(mesage), "IRC \"%s\": %s ", user, message);
      SendClientMessageToAll(0xDEEE20FF, mesage);
   }
   return 1;
}



public IRC_OnReceiveRaw(botid, message[]){
	new	File:file,output[1536];
 	strmid(output, message, 0, sizeof(output), sizeof(output));
	if (!fexist("irc_log.txt")){
		file = fopen("irc_log.txt", io_write);
		fwrite(file, output);
		fclose(file);
	}
	else {
		file = fopen("irc_log.txt", io_append);
		fwrite(file, output);
		fclose(file);
	}
	return 1;
}

public IRC_ConnectDelay(tempid)
{
	switch (tempid)
	{
		case 1:{gBotID[0] = IRC_Connect(IRC_SERVER, IRC_PORT, BOT_1_NICKNAME, BOT_1_REALNAME, BOT_1_USERNAME);}
	}
	return 1;
}
#endif
/*IRC */

//дуэли by krors_rus
giverep(playerid,inc){
	new wantedlevel,newlev;
	wantedlevel = GetPlayerWantedLevel(playerid);
    newlev=inc+wantedlevel;
	if (newlev<=6){
	if (newlev>=0){
	//SetPlayerWantedLevel(playerid, newlev);
	}
	}
	return 1;
}
gotozone(){

	switch(gzone)
    {
    case 0: {
    SetPlayerPos(gplay1,2563.1174,2844.4907,10.8203);
    SetPlayerPos(gplay2,2606.9246,2811.3215,10.8203);
    }
    case 1: {
    SetPlayerPos(gplay1,-1417.6503,488.4842,3.0391);
    SetPlayerPos(gplay2,-1378.4501,512.6349,3.0391);
    }
    case 2: {
    SetPlayerPos(gplay1,-1289.6942,510.9169,11.1953);
    SetPlayerPos(gplay2,-1445.3356,501.1401,11.1953);
    }
    case 3: {
    SetPlayerPos(gplay1,-1380.3756,1494.6877,1.8516);
    SetPlayerPos(gplay2,-1435.8257,1488.7047,1.8672);
    }
    case 4: {
    SetPlayerPos(gplay1,-1362.7911,1488.6329,11.0391);
    SetPlayerPos(gplay2,-1479.8959,1489.4751,8.2578);
    }
    }
	return 1;
}

duels(playerid){
	new or2[MAX_STRING],str[MAX_STRING];//,string3[256],string4[125],name1[MAX_PLAYER_NAME];
    switch(gduel)
    {
       case 0: {
	      gplay1=playerid;
	      or2=getweapname(gweapon2);
	      if(gDuelTetATet==1){
             format(str, sizeof(str), "Игрок %s вызывает %s на дуэль!",PlayerInfo[playerid][Name],PlayerInfo[PlayerInfo[playerid][TargetID]][Name]);
             WriteEcho(str);
             format(str, sizeof(str), "Оружие:  %s ",or2);
             WriteEcho(str);
             WriteEcho("Пишите /duel чтобы присоедениться!",PlayerInfo[playerid][TargetID]);
	      }
	      else {
	         format(str, sizeof(str), "Игрок %s создал дуэль!",PlayerInfo[playerid][Name]);
	         WriteEcho(str);
	         format(str, sizeof(str), "Оружие:  %s ",or2);
	         WriteEcho(str);
	         WriteEcho("Пишите /duel чтобы присоедениться!");
		     PlayerInfo[playerid][DuelCreate] = 1;
		  }
	      /*  Перейти на следующий режим */
	      gduel=1;
       }
	   case 1:{ WriteEcho("Дуэль уже создана", playerid,0xFFFF00AA );}// Сообщить, что дуэль создана
	   case 2:{ WriteEcho("Дуэль сейчас проходит. Попробуй позже", playerid, 0xFFFF00AA);}// Сообщить, что дуэль проходит сейчас
	}
	return 1;
}
stopduel(playerid){
    switch(gduel)
    {
       case 0:{ WriteEcho("Дуэль не создана", playerid, ErrorMsgColor);}
	   case 1:{ WriteEcho("Дуэль отменена администратором", INVALID_PLAYER_ID, ErrorMsgColor); gduel=0; gDuelTetATet=0;}
	   case 2:{
          WriteEcho("Дуэль отменена администратором", INVALID_PLAYER_ID, ErrorMsgColor);
 	      gduel=0;
 	      gDuelTetATet=0;
 	      SpawnPlayer(gplay1);
 	      SpawnPlayer(gplay2);
          KillTimer(gtimm);
 	      shotag(1);
	   }
	}
	return 1;
}
duelj(playerid){
    switch(gduel)
    {
       case 0: { WriteEcho("Нужно создать дуэль.", playerid); }
	   case 1: {
	      if(PlayerInfo[playerid][DuelCreate] == 1){
	         WriteEcho("Ты уже создал дуэль!", playerid);
          }
          if(gDuelTetATet==1){
			 new str[MAX_STRING];
			 if(playerid!=PlayerInfo[gplay1][TargetID]){
			    format(str,sizeof(str),"Извените, но %s вызвал на дуэль %s, а не вас.",PlayerInfo[gplay1][Name],PlayerInfo[PlayerInfo[gplay1][TargetID]][Name]);
				WriteEcho(str,playerid,ErrorMsgColor);
             }
             else {
	            gplay2=playerid;
	            PlayerInfo[playerid][DuelChange] = 1;
                format(str, sizeof(str), "Дуэль: %s vs %s", PlayerInfo[gplay1][Name],PlayerInfo[playerid][Name]);
                WriteEcho(str);
	            if(IsPlayerInAnyVehicle(gplay1)) RemovePlayerFromVehicle(gplay1);
	            if(IsPlayerInAnyVehicle(gplay2)) RemovePlayerFromVehicle(gplay2);
	            gotozone();
	            gtimm=SetTimer("ztime",300000,false);
	            GameTextForPlayer(gplay1, "You have 2 minutes!", 3000, 5);
	            GameTextForPlayer(gplay2, "You have 2 minutes!", 3000, 5);
	            SetPlayerHealth(gplay1, 100);
	            SetPlayerHealth(gplay2, 100);
	            SetPlayerVirtualWorld(gplay1, 0);
	            SetPlayerVirtualWorld(gplay2, 0);
	            SetPlayerArmour(gplay2, 0.0);
	            SetPlayerArmour(gplay2, 0.0);
                shotag(0);
                ResetPlayerWeapons(gplay1);
                ResetPlayerWeapons(gplay2);
	            setweapslot(gplay1,gweapon2);
	            setweapslot(gplay2,gweapon2);
                gduel=2;
             }
          }
          else {
	         gplay2=playerid;
	         PlayerInfo[playerid][DuelChange] = 1;
	         new str[MAX_STRING];//, name1[MAX_PLAYER_NAME], name2[MAX_PLAYER_NAME]
             /*GetPlayerName(gplay1, name1, sizeof(name1));
             GetPlayerName(gplay2, name2, sizeof(name2));*/
             format(str, sizeof(str), "Дуэль: %s vs %s", PlayerInfo[gplay1][Name],PlayerInfo[playerid][Name]);
             WriteEcho(str);
	         if(IsPlayerInAnyVehicle(gplay1)) RemovePlayerFromVehicle(gplay1);
	         if(IsPlayerInAnyVehicle(gplay2)) RemovePlayerFromVehicle(gplay2);
	         gotozone();
	         gtimm=SetTimer("ztime",300000,false);
	         GameTextForPlayer(gplay1, "You have 2 minutes!", 3000, 5);
	         GameTextForPlayer(gplay2, "You have 2 minutes!", 3000, 5);
	         SetPlayerHealth(gplay1, 100);
	         SetPlayerHealth(gplay2, 100);
	         SetPlayerVirtualWorld(gplay1, 0);
	         SetPlayerVirtualWorld(gplay2, 0);
	         SetPlayerArmour(gplay2, 0.0);
	         SetPlayerArmour(gplay2, 0.0);
             shotag(0);
             ResetPlayerWeapons(gplay1);
             ResetPlayerWeapons(gplay2);
	         setweapslot(gplay1,gweapon2);
	         setweapslot(gplay2,gweapon2);
             gduel=2;
	      }
	   }
	   case 2:{ WriteEcho("Дуэль сейчас проходит. Попробуй позже", playerid);}
	}
    return 1;
}
shotag(or){
	if (or==1){}
    else {}
    return 1;
}
noduel(playerid){
    switch(gduel)
    {
       case 0:{ WriteEcho("Вы не создавали дуэль", playerid);}
	   case 1:{
	      if(PlayerInfo[playerid][DuelCreate] == 1){
	         WriteEcho("Ты отказался от дуэли.", playerid);
	         gduel=0;
	         gplay1=0;
	         gDuelTetATet=0;
	         PlayerInfo[playerid][DuelCreate] = 0;
	         KillTimer(gtimm);
	      }
	      else WriteEcho("Ты итак не принимаешь участия в дуэли.", playerid);
	   }
	   case 2:{
	      if(playerid==gplay1 || playerid==gplay2){ WriteEcho("Дуэль сейчас проходит, надо было думать раньше!", playerid);}
	      else WriteEcho("Ты итак не принимаешь участия в дуэли.", playerid);
	   }
	}
	return 1;
}
setweapslot(playerid,weap){
	switch(weap)
	{
	   case 0:{GivePlayerWeapon(playerid, 31, 600);GivePlayerWeapon(playerid, 29, 420);}
	   case 1:{GivePlayerWeapon(playerid, 31, 1000);GivePlayerWeapon(playerid, 25, 100);}
	   case 2:{GivePlayerWeapon(playerid, 31, 800);GivePlayerWeapon(playerid, 33, 120);}
	   case 3:{GivePlayerWeapon(playerid, 31, 400);GivePlayerWeapon(playerid, 24, 80);}
	   case 4:{GivePlayerWeapon(playerid, 24, 140);GivePlayerWeapon(playerid, 30, 360);}
	   case 5:{GivePlayerWeapon(playerid, 24, 140);GivePlayerWeapon(playerid, 29, 540);}
	   case 6:{GivePlayerWeapon(playerid, 25, 100);GivePlayerWeapon(playerid, 34, 100);}
	   case 7:{GivePlayerWeapon(playerid, 34, 70);GivePlayerWeapon(playerid, 30, 420);}
	   case 8:{GivePlayerWeapon(playerid, 34, 70);GivePlayerWeapon(playerid, 29, 540);}
	   case 9:{GivePlayerWeapon(playerid, 16, 6);GivePlayerWeapon(playerid, 25, 100);}
	   case 10:{GivePlayerWeapon(playerid, 16, 6);GivePlayerWeapon(playerid, 31, 250);}
	   case 11:{GivePlayerWeapon(playerid, 24, 70);GivePlayerWeapon(playerid, 25, 100);}
	}
	return 1;
}
getweapname(id){
    new string2[MAX_STRING];
    switch(id)
	{
		case 0:  format(string2, sizeof(string2), "M4+MP5");
		case 1:  format(string2, sizeof(string2), "M4+Shotgun");
		case 2:  format(string2, sizeof(string2), "M4+Rifle");
		case 3:  format(string2, sizeof(string2), "M4+Deagle");
		case 4:  format(string2, sizeof(string2), "Deagle+AK-47");
		case 5:  format(string2, sizeof(string2), "Deagle+MP5");
		case 6:  format(string2, sizeof(string2), "Sniper+Shotgun");
		case 7:  format(string2, sizeof(string2), "Sniper+AK-47");
		case 8:  format(string2, sizeof(string2), "Sniper+MP5");
		case 9:  format(string2, sizeof(string2), "Shotgun+Grenade");
		case 10:  format(string2, sizeof(string2), "Grenate+M4");
		case 11:  format(string2, sizeof(string2), "Deagle+Shotgun");

	}
	return string2;
}

public ztime()
{
	if (gduel==2){
	   WriteEcho("Время дуэли вышло", INVALID_PLAYER_ID, ErrorMsgColor);
	   gduel=0;
	   PlayerInfo[gplay1][DuelCreate] = 0;
	   PlayerInfo[gplay2][DuelChange] = 0;
 	   SpawnPlayer(gplay1);
 	   SpawnPlayer(gplay2);
	}
	return 1;
}
textDuelInMenu(playerid)
{
   new str[MAX_STRING];
   if(gduel==0) format(str,sizeof(str)," (создать)");
   if(gduel==1 && PlayerInfo[playerid][DuelCreate] == 1) format(str,sizeof(str)," (отменить)");
   if(gduel==1 && PlayerInfo[playerid][DuelCreate] == 0) format(str,sizeof(str)," (принять)");
   if(gduel==2) format(str,sizeof(str)," [%s vs %s] (Ждите)",PlayerInfo[gplay1][Name],PlayerInfo[gplay2][Name]);
   return str;
}
//дуэли by kroks_rus
