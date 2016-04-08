#include "ofApp.h"

using namespace ofxAssets;

//--------------------------------------------------------------
void ofApp::setup2(){
	ofSetWindowTitle("Digital Emulsion Toolkit v0.1");
	ofSetCircleResolution(120);
	
	splashScreen.init("splashScreen.png");
	splashScreen.begin(0.0f);
	
	//auto cameraTest = MAKE(EDSDK);
	//world.add(cameraTest);

	auto cameraDevice = MAKE(ofxMachineVision::Device::CanonDSLRDevice);
	auto cameraNode = MAKE(ofxDigitalEmulsion::Item::Camera);
	cameraNode->setDevice(cameraDevice);
	world.add(cameraNode);

	
	auto kinect = MAKE(ofxDigitalEmulsion::Item::KinectV2);
	this->world.add(kinect);

	auto checkerboard = MAKE(ofxDigitalEmulsion::Item::Checkerboard);
	this->world.add(checkerboard);

	auto cameraFromKinect = MAKE(ofxDigitalEmulsion::Procedure::Calibrate::CameraFromKinectV2);
	cameraFromKinect->connect(cameraNode);
	cameraFromKinect->connect(kinect);
	cameraFromKinect->connect(checkerboard);
	this->world.add(cameraFromKinect);

	for (int i = 0; i < PROJECTOR_COUNT; i++) {
		auto projectorOutput = MAKE(ofxDigitalEmulsion::Device::ProjectorOutput);
		projectorOutput->setName("Projector Output " + ofToString(i));
		this->world.add(projectorOutput);

		auto projector = MAKE(ofxDigitalEmulsion::Item::Projector);
		projector->setName("Projector " + ofToString(i));
		this->world.add(projector);

		auto projectorFromKinect = MAKE(ofxDigitalEmulsion::Procedure::Calibrate::ProjectorFromKinectV2);
		projectorFromKinect->connect(projectorOutput);
		projectorFromKinect->connect(kinect);
		projectorFromKinect->connect(projector);
		projectorFromKinect->setName("Projector From Kinect " + ofToString(i));
		this->world.add(projectorFromKinect);
	}

	this->gui.init();
	this->world.init(this->gui.getController());
	this->world.loadAll();
	
	this->splashScreen.end();
	
}

//--------------------------------------------------------------
void ofApp::update(){
	this->world.update();
}

//--------------------------------------------------------------
void ofApp::draw(){
	if (ofGetFrameNum() == 2) {
		this->setup2();
	}
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
