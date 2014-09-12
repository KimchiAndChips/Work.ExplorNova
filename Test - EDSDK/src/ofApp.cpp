#include "ofApp.h"

using namespace ofxAssets;

//--------------------------------------------------------------
void ofApp::setup2(){
	ofSetWindowTitle("Digital Emulsion Toolkit v0.1");
	ofSetCircleResolution(120);
	
	splashScreen.init("splashScreen.png");
	splashScreen.begin(0.0f);
	
	auto cameraTest = MAKE(EDSDK);
	this->world.add(cameraTest);

	auto kinect = MAKE(ofxDigitalEmulsion::Item::KinectV2);
	this->world.add(kinect);

	auto projectorOutput = MAKE(ofxDigitalEmulsion::Device::ProjectorOutput);
	this->world.add(projectorOutput);

	auto projector = MAKE(ofxDigitalEmulsion::Item::Projector);
	this->world.add(projector);

	auto projectorFromKinect = MAKE(ofxDigitalEmulsion::Procedure::Calibrate::ProjectorFromKinectV2);
	projectorFromKinect->connect(projectorOutput);
	projectorFromKinect->connect(kinect);
	projectorFromKinect->connect(projector);
	this->world.add(projectorFromKinect);

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
