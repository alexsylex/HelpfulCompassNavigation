﻿import FocusedMarker;

// Instances
var CompassFrame:MovieClip;
var CompassTemperatureHolderInstance:MovieClip;
var CompassMask_mc:MovieClip;
var DirectionRect:MovieClip;

var FocusedMarkerInstance:FocusedMarker;
var QuestTitle:MovieClip;
var QuestObjective:MovieClip;

// References
var MarkerList:Array;
var QuestTitleText:TextField;
var QuestTitleEndPieces:MovieClip;
var QuestObjectiveText:TextField;

function Compass(a_x:Number, a_y:Number, a_hadTemperatureMeter:Boolean):Void
{
	_x = a_x;
	_y = a_y;

	if (a_hadTemperatureMeter)
	{
		_root.HUDMovieBaseInstance.TemperatureMeter_mc = CompassTemperatureHolderInstance;
	}
	else
	{
		// We have it, but we will not use it
		CompassTemperatureHolderInstance.gotoAndStop("Empty");
	}

	_root.HUDMovieBaseInstance.CompassRect = DirectionRect;

	// References
	MarkerList = _root.HUDMovieBaseInstance.CompassMarkerList;

	QuestTitleText = QuestTitle.TitleText;
	QuestTitleEndPieces = QuestTitle.EndPieces;

	QuestObjectiveText = QuestObjective.RolloverText;
}

function SetQuestInfo(a_questType:Number, a_questName:String, a_questObjective:String,
					  a_distance:Number):Void
{
	FocusedMarkerInstance.Distance.TextFieldInstance.text = String(Math.floor(a_distance)) + " m";
	FocusedMarkerInstance.Objective.TextFieldInstance.text = a_questObjective;

	//QuestTitle._alpha = 100;
	//QuestTitleEndPieces.gotoAndStop(a_questType);
	//QuestTitleText.text = a_questName.toUpperCase();
	//QuestObjective._alpha = 100;
	//QuestObjectiveText.text = a_questObjective;

	//var bracketsOpenFrame:Number = Math.round(a_questObjective.length * 2.25);
	//QuestObjective.gotoAndStop(bracketsOpenFrame);
}

function SetLocationInfo(a_locationName:String, a_distance:Number):Void
{
	FocusedMarkerInstance.Distance.TextFieldInstance.text = String(Math.floor(a_distance)) + " m";
	FocusedMarkerInstance.Objective.TextFieldInstance.text = a_locationName;
}

function FocusMarker(a_markerIndex:Number):Void
{
	FocusedMarkerInstance.index = a_markerIndex;

	FocusedMarkerInstance.movie = MarkerList[FocusedMarkerInstance.index].movie;
	FocusedMarkerInstance.gotoAndPlay("FadeIn");
}

function Update(a_markerIndex:Number):Void
{
	if (FocusedMarkerInstance.index != a_markerIndex)
	{
		FocusedMarkerInstance.index = a_markerIndex;
		FocusedMarkerInstance.movie = MarkerList[FocusedMarkerInstance.index].movie;
	}

	//var MarkerList_length:Number = MarkerList.length;
	//for (var i:Number = 0; i < MarkerList_length; i++)
	//{
		//var marker:MovieClip = MarkerList[i].movie;
//
		//if (i == FocusedMarkerInstance.index)
		//{
			//marker._xscale = Math.max(150, marker._xscale);
			//marker._yscale = Math.max(150, marker._yscale);
		//}
		//else
		//{
			//marker._xscale /= 1.2;
			//marker._yscale /= 1.2;
		//}
	//}

	FocusedMarkerInstance._x = localToLocal(FocusedMarkerInstance.movie, this).x;
	FocusedMarkerInstance._alpha = Math.max(FocusedMarkerInstance.movie._alpha, 75);

	_level0.Test.TextField2.text = "Focused marker[" + String(FocusedMarkerInstance.index) + "]: " + FocusedMarkerInstance.movie;
}

function UnfocusMarker(a_markerIndex:Number):Void
{
	FocusedMarkerInstance.gotoAndPlay("FadeOut");

	FocusedMarkerInstance.index = -1;

	QuestTitle._alpha = 0;
	QuestObjective._alpha = 0;
}

function localToLocal(from:MovieClip, to:MovieClip):Object
{
	var point:Object = { x:0, y:0 };
	from.localToGlobal(point);
	to.globalToLocal(point);
	return point;
}
