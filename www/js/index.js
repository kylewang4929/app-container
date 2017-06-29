/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },
    
    startAndLogin: function() {
      var phone = "REPLACE_WITH_YOUR_PHONE_NUMBER";
      var password = "111111";
      var email = "yliu@gizwits.com"
      
      cordova.plugins.GizWifiCordovaSDK.startWithAppID({
        "appID": "42a7563f305342ae805cbb21d968a0ce"
      }, function(data) {
        alert("SDK Started");
        cordova.plugins.GizWifiCordovaSDK.userLogin({"userName": email, "password": password}, function(data) {
          alert("User logged in: " + JSON.stringify(data));
        }, function(error) {
          alert("User failed to login: " + JSON.stringify(error));
        });
      }, function(error) {
        alert("SDK failed to start: " + JSON.stringify(error));
      });
    },
    
    startAndRequestVerificationCode: function() {
      var phone = "REPLACE_WITH_YOUR_PHONE_NUMBER";
      
      cordova.plugins.GizWifiCordovaSDK.startWithAppID({
        "appID": "42a7563f305342ae805cbb21d968a0ce"
      }, function(data) {
        alert("SDK Started");
        cordova.plugins.GizWifiCordovaSDK.requestSendVerifyCode(
          {"phone": phone, "appSecret": "dc5b945db45f427c97ec9ae881850623"},
          function(data) {
            alert("Got verification code: " + JSON.stringify(data));
          },
          function(error) {
            alert("Error getting verification code: " + JSON.stringify(error));
          }
        );
      }, function(error) {
        alert("SDK failed to start: " + JSON.stringify(error));
      });
    },
    
    startAndRegisterUserByPhone: function() {
      var phone = "REPLACE_WITH_YOUR_PHONE_NUMBER";
      var code = "VERIFICATION_CODE_GOT_FROM_SMS";
      
      var GizUserNormal	= 0; // 普通用户
      var GizUserPhone	= 1; // 手机用户
      var GizUserEmail	= 2; // 邮箱用户
      
      cordova.plugins.GizWifiCordovaSDK.startWithAppID({
        "appID": "42a7563f305342ae805cbb21d968a0ce"
      }, function(data) {
        alert("SDK Started");
        cordova.plugins.GizWifiCordovaSDK.registerUser(
          {"userName": phone, "password": "123456", "verifyCode": code, "accountType": GizUserPhone},
          function(data) {
            alert("User registered: " + JSON.stringify(data));
          },
          function(error) {
            alert("Failed to register user: " + JSON.stringify(error));
          }
        );
      }, function(error) {
        alert("SDK failed to start: " + JSON.stringify(error));
      });
    },
    
    startAndRegisterUserByEmail: function() {
      var email = "REPLACE_WITH_YOUR_EMAIL";
      
      var GizUserNormal	= 0; // 普通用户
      var GizUserPhone	= 1; // 手机用户
      var GizUserEmail	= 2; // 邮箱用户
      
      cordova.plugins.GizWifiCordovaSDK.startWithAppID({
        "appID": "42a7563f305342ae805cbb21d968a0ce"
      }, function(data) {
        alert("SDK Started");
        cordova.plugins.GizWifiCordovaSDK.registerUser(
          {"userName": email, "password": "123456", "accountType": GizUserEmail},
          function(data) {
            alert("User registered: " + JSON.stringify(data));
          },
          function(error) {
            alert("Failed to register user: " + JSON.stringify(error));
          }
        );
      }, function(error) {
        alert("SDK failed to start: " + JSON.stringify(error));
      });
    },
    
    changeUserPassword: function() {
      var token = "8a49f6f15e0c4e82863b04ab764d0c4b";
      var uid = "a64bfd3605f440d497eada93044e6520";
      
      cordova.plugins.GizWifiCordovaSDK.changeUserPassword(
        {"token": token, "oldPassword": "123456", "newPassword": "111111"},
        function(data) {
          alert("Password changed: " + JSON.stringify(data));
        },
        function(error) {
          alert("Failed to change password: " + JSON.stringify(error));
        }
      );
    },
    
    resetPasswordByEmail: function() {
      var email = "yliu@gizwits.com";
      
      var GizUserNormal	= 0; // 普通用户
      var GizUserPhone	= 1; // 手机用户
      var GizUserEmail	= 2; // 邮箱用户
      
      cordova.plugins.GizWifiCordovaSDK.resetPassword(
        {"userName": email, "verifyCode": "", "newPassword": "", "accountType": GizUserEmail},
        function(data) {
          alert("Password reset: " + JSON.stringify(data));
        },
        function(error) {
          alert("Failed to reset password: " + JSON.stringify(error));
        }
      );
    },
    
    getUserInfo: function() {
      var token = "8a49f6f15e0c4e82863b04ab764d0c4b";
      
      cordova.plugins.GizWifiCordovaSDK.getUserInfo(
        {"token": token},
        function(data) {
          alert("User Info: " + JSON.stringify(data));
        },
        function(error) {
          alert("Failed to get user info: " + JSON.stringify(error));
        }
      );
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function() {
        this.receivedEvent('deviceready');
        
        // Following is 'getVersion'
        // cordova.plugins.GizWifiCordovaSDK.getVersion(function(version) {
        //   alert("Version: " + JSON.stringify(version));
        // }, function(error) {
        //   alert("Error getting version: " + JSON.stringify(error));
        // });
        
        // This one is start SDK and login
        this.startAndLogin();
        
        // This is to request a verification code
        // this.startAndRequestVerificationCode();
        
        // This one is start and register a new user
        // this.startAndRegisterUserByPhone();
        
        // This one to register a user with email
        // this.startAndRegisterUserByEmail();
        
        // This one is to change user password, it depends on startAndLogin()
        // this.changeUserPassword();
        
        // This is to reset password by email
        // FIXME: This one didn't pass the test
        // this.resetPasswordByEmail();
        
        // This is to test getUserInfo
        this.getUserInfo();
        
        
    },

    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);
    }
};

app.initialize();