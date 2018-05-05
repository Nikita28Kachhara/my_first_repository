/ Arduino Sketch to Enroll ID 
#include "FPS_GT511C3.h"
#include "SoftwareSerial.h"

FPS_GT511C3 fps(5, 4);          //    digital pin 5(arduino Tx, fps Rx)
                                //    digital pin 4(arduino Rx, fps Tx)
void setup()
{
  Serial.begin(9600);           //default baud rate
	delay(100);
	fps.Open();
	fps.SetLED(true);

	Enroll();
}


void Enroll()
{
	int enrollid = 0;             // find open enroll id
	bool okid = true;
	while (okid == true)
	{
		okid = fps.CheckEnrolled(enrollid);
		if (okid==true) enrollid++;
	}
	fps.EnrollStart(enrollid);   // enroll

	
	Serial.print("Press finger to Enroll #"); 
	Serial.println(enrollid);
	while(fps.IsPressFinger() == false) delay(100);
	bool bret = fps.CaptureFinger(true);
	int iret = 0;
	if (bret != false)
	{
		Serial.println("Remove finger");
		fps.Enroll1(); 
		while(fps.IsPressFinger() == true) delay(100);
		Serial.println("Press same finger again");
		while(fps.IsPressFinger() == false) delay(100);
		bret = fps.CaptureFinger(true);
		if (bret != false)
		{
			Serial.println("Remove finger");
			fps.Enroll2();
			while(fps.IsPressFinger() == true) delay(100);
			Serial.println("Press same finger yet again");
			while(fps.IsPressFinger() == false) delay(100);
			bret = fps.CaptureFinger(true);
			if (bret != false)
			{
				Serial.println("Remove finger");
				iret = fps.Enroll3();
				if (iret == 0)
				{
					Serial.println("Enrolling Successfull");
				}
				else
				{
					Serial.print("Enrolling Failed with error code:");
					Serial.println(iret);
				}
			}
			else Serial.println("Failed to capture third finger");
		}
		else Serial.println("Failed to capture second finger");
	}
	else Serial.println("Failed to capture first finger");
}


void loop()
{
	delay(100);
}

// Arduino Sketch to get ID
#include "FPS_GT511C3.h"
#include "SoftwareSerial.h"

FPS_GT511C3 fps(5, 4);          //    digital pin 5(arduino Tx, fps Rx)
                                //    digital pin 4(arduino Rx, fps Tx)
void setup()
{
  Serial.begin(9600);           //default baud rate
	delay(100);
	fps.Open();
	fps.SetLED(true);
}

void loop()
{

	// Identify fingerprint test
	if (fps.IsPressFinger())
	{
		fps.CaptureFinger(false);
		int id = fps.Identify1_N();
		if (id <200)
		{
			Serial.print("Verified ID:");
			Serial.println(id);
		}
		else
		{
			Serial.println("Finger not found");
		}
	}
	else
	{
		Serial.println("Please press finger");
	}
	delay(100);
}
