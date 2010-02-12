/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api
{ 
	import com.adobe.serialization.json.JSON;
	import com.yammer.api.constants.*;
	import com.yammer.api.signals.*;
	import com.yammer.api.utils.*;
	import com.yammer.api.vo.*;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	
	import org.osflash.signals.Signal;
	
	
	public class Yammer
	{	
		/**
		 * @private
		 */
		protected var urlRequest:URLRequest;
		
		/**
		 * @private
		 */
		protected var urlLoader:URLLoader;
		
		/**
		 * @private
		 */
		protected var consumerKey:String;
		
		/**
		 * @private
		 */
		protected var consumerSecret:String;
		
		/**
		 * @private
		 */
		protected var oauth:Oauth;
		
		/**
		 * @private
		 */
		protected var oauthVerifier:String;
		
		/**
		 * @private
		 */
		protected var airClient:Boolean = false;
		
		/**
		 * @private
		 */
		protected var downloadFile:FileReference; 
		
		/**
		 * @private
		 */
		protected var searchTerm:String;
		
		
		/**
		 * Signal for results
		 * */
		public var resultsReceived:Signal;
		public var eventCompleted:EventCompletedSignal;
		public var errorReceived:ErrorReceivedSignal;
		public var httpStatusUpdated:HttpStatusUpdatedSignal;
		
		/**
		 * Yammer library handles connecting to the Yammer API (https://www.yammer.com/api_doc.html). 
		 * The initialize method allows you to authenticate requests by passing the user's credentials
		 * and sign requests by passing your application's credentials.
		 * 
		 * <p>The Yammer service uses AS3 Signals to broadcast when request results are received or if
		 * an error occured with the service call. There are three types of signals:
		 * 
		 * Signal - the default AS3 Signal used for results of service call
		 * ErrorReceivedSignal - custom signal used for error received with service call, contains <code>YammerError</code> object
		 * EventCompleteSignal - sent when the service just returns status 200, this returns nothing
		 * HttpStatusUpdatedSignal - sends updates of the http status codes, type is int
		 * 
		 * For more information about AS3 Signals: http://github.com/robertpenner/as3-signals
		 * </p>
		 *
		 * <p>Here's an example of authorizing the Yammer service and doing the OAuth dance.  
		 * Please note you will need your own consumer key and secret for the Yammer API available at:
		 * https://www.yammer.com/yammerdevelopersnetwork/client_applications/new </p>
		 *
		 * <listing>
		 * import com.yammer.api.Yammer;
		 * import com.yammer.api.vo.YammerError
		 * import com.yammer.api.vo.YammerMessageList;
		 * import com.yammer.api.vo.YammerTab;
		 * import com.yammer.api.vo.YammerUser;
		 *
		 * // private vars
		 * private var service:Yammer;
		 * private var consumerKey:String;  // your consumer key
		 * private var consumerSecret:String // your consumer secret
		 * 
		 * private var oauthToken:String;
		 * private var oauthSecret:String;
		 * 
		 * // Initialize the service.  If you already have oauthToken and oathSecret you can
		 * // use them to initize the service, if not then you must get set these values 
		 * // by getting a reqeust token and verify pin to authorize your application.
		 * private function initializeService():void {
		 * 		// replace with your own consumer key and secret values
		 * 		service:Yammer = new Yammer(consumerKey, consumerSecret); 
		 * 		service.errorReceived.add errorReceived);
		 * 
		 * 		if(oauthToken && oauthSecret) { 
		 * 			// we previously authorized app and set the values in the service using stored oauth values
		 * 			service.setOuthTokens(oauthToken, oauthSecret);
		 * 		} else { 
		 * 			// first time to authorize app and so we do the aouth dance
		 * 			service.resultsReceived.add(requestTokenReceived);
		 * 			service.requestToken(); 
		 * 		}
		 * }
		 *
		 * //Handle request token event, returns request token and secret. 
		 * private function requestTokenReceived(event:YammerEvent):void {
		 * 		service.resultsReceived.remove(requestTokenReceived);
		 *		service.sendAuthorizationRequest(); // open browser window to autorize application and get verify pin
		 * }
		 * 
		 * //Users must manually copy and enter the verify pin from the request authorization browser page
		 * private function requestAccessToken(verify_pin:String):void {
		 *  	service.resultsReceived.add(accessTokenReceived);
		 * 		service.accessToken(verify_pin);
		 * }
		 * 
		 * //Handle access token event, returns access token and secret. 
		 * private function accessTokenReceived(value:Oauth):void {
		 * 		service.resultsReceived.add(accessTokenReceived);
		 * 		
		 * 		// You may want to store these values in SO or local store so you can set have next time application is run
		 *		oauthToken = value.oauth_token;
		 *		oauthSecret = value.oauth_token_secret;
		 * }
		 *
		 * // Send request for current user
		 * private function getCurrentUser():void {
		 * 		service.resultsReceived.add(currentUserReceived);
		 * 		service.getCurrentUser();
		 * }
		 * 
		 * // The user is returned as a YammerUser object
		 * private function currentUserReceived(value:CurrentYammerUser):void
		 * {
		 * 		service.resultsReceived.remove(currentUserReceived);
		 * 		var user:YammerUser = value;
		 * 		getMessages(user.tabs[0] as YammerTab); // get the first tab of the current user
		 * }
		 * 
		 * // Get a list of messages for the main tab of the current user
		 * private function getMessages(tab:YammerTab):void {
		 * 		service.resultsReceived.add(messageListReceived);
		 * 		service.getMessages(tab.url); // the url of the tab
		 * }
		 * 
		 * // Messages are returned in a YammerMessageList object
		 * private function messageListReceived(value:YammerMessageList):void {
		 * 		service.resultsReceived.remove(handleMessageList);
		 * 		var messageList:YammerMessageList = value;
		 * 		var messages:Array = messageList.getMessages();
		 * }
		 * 
		 * private function errorReceived(error:YammerError):void {
		 *     //Handle failure
		 * }
		 * </listing>
		 */ 
		public function Yammer(consumerKey:String = null, consumerSecret:String = null):void
		{
			if (consumerKey && consumerSecret) setConsumerInformation(consumerKey, consumerSecret);
			
			airClient = (Capabilities.playerType.toLowerCase() == "desktop") ? true : false; // are we using an AIR application?
			
			oauth = new Oauth();
			resultsReceived = new Signal();
			eventCompleted = new EventCompletedSignal();
			errorReceived = new ErrorReceivedSignal();
			httpStatusUpdated = new HttpStatusUpdatedSignal();
		}
		
		/**
		 * Sets the credentials for the Yammer application.
		 * 
		 * @param consumerKey the consumer key
		 * @param consumerSecret the consumer secret 
		 */
		public function setConsumerInformation(consumerKey:String, consumerSecret:String):void 
		{
			this.consumerKey = consumerKey;
			this.consumerSecret = consumerSecret;
		}
	
		
	//---------------------------------------------------------------//
	//----------------  AUTHENTICATION METHODS  ---------------------/
	//--------------------------------------------------------------//
		
		/**
		 * Sets the oauth token information from previously saved data.
		 * 
		 * @param oauthToken the consumer key
		 * @param oauthTokenSecret the consumer secret 
		 */
		public function setOuthTokens(oauthToken:String, oauthTokenSecret:String):void 
		{
			this.oauth = new Oauth(oauthToken, oauthTokenSecret);
		}
	
		/**
		 * Request token from the service for your application with your consumer key and secret values. 
		 * The request will return an oauth secret and key.
		 * 
		 * @param consumer_key  The application consumer key
		 * @param consumer_secret The application consumer secret
		 * 
		 * @return <code>Oauth</code> object
		 * */
		public function requestToken():void 
		{	
			var params:Object = new Object();
			
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
				
			var urlRequest:URLRequest = createRequest(YammerPaths.OAUTH_REQUEST_TOKEN, params);
			
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onRequestToken);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOErrorXML);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Save the returned oauth secret and key values.
		 * @private
		 * */
		private function onRequestToken(event:Event):void
		{
			var urlvars:URLVariables = new URLVariables(String(event.target.data));
			
			this.oauth = new Oauth(urlvars.oauth_token, urlvars.oauth_token_secret);
			
			resultsReceived.dispatch(this.oauth);
		}
		
		/**
		 *  Once we have the request tokens, we direct user to the Yammer website for to get the verification pin.
		 *  This will open the users default web browse. 
		 * 
        * */
        public function sendAuthorizationRequest():void 
        {
			var urlRequest : URLRequest = new URLRequest ();
				urlRequest.url = YammerPaths.OAUTH_AUTHORIZE + "?oauth_token=" + this.oauth.oauth_token;
				
			navigateToURL(urlRequest, "_blank");  
		}
		
		/**
		 * If you want to optionally get the path to open your own browser window for getting the verify pin
		 * you can pass in the returned token fro the requestToken method and get the complete path.
		 * 
		 * @param oauth_token The token returned from requestToken() call
		 * @return String value for the authorization url to launch in external browser window
		 * */
		public function getAuthorizationRequestPath(oauth_token:String):String 
		{
			return YammerPaths.OAUTH_AUTHORIZE + "?oauth_token=" + oauth_token; 
		}
		
		/**
		 * Getting the Oauth Verify pin is retrieved by sending users to the Yammer web site for authorization. After authorizing 
		 * the appliation, user will need to copy the pin into your application.
		 * 
		 * @param verify_pin The Oauth verification pin
		 * 
		 * @return <code>Oauth</code> object
		 * */
		public function accessToken( verify_pin:String ):void 
		{
			this.oauthVerifier = verify_pin;
			var params:Object = new Object();
			
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
	
			var urlRequest:URLRequest = createRequest(YammerPaths.OAUTH_ACCESS_TOKEN, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onAccessToken);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Returns the oauth token and secret so the application may store these values the
		 * next time the user logs into the application. 
		 * */
		private function onAccessToken(event:Event):void
		{
			var xml:XML = new XML(event.target.data);	
			var urlvars:URLVariables = new URLVariables(String(event.target.data));
			
			this.oauth = new Oauth(urlvars.oauth_token, urlvars.oauth_token_secret);
		
			resultsReceived.dispatch(this.oauth);
		}
		
		/**
		 * For those clients that have special privileges, they can use the Yammer service WRAP controller 
		 * to get the users access tokens simply by supplying the username and password for the user.  The 
		 * call returns the oauth access token and secret needed for signing calls to the Yammer API. 
		 * 
		 * @param username Yammer username
		 * @param password Yammer password;
		 * 
		 * @return <code>Oauth</code> object
		 * */
		public function accessWrapToken(username:String, password:String):void
		{
			var params:Object = new Object();
				params.wrap_username = username;
				params.wrap_password = password;
				params.wrap_client_id = this.consumerKey;
				
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
			
			var urlRequest:URLRequest = createRequest(YammerPaths.OAUTH_WRAP_ACCESS_TOKEN, params);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onAccessWrapToken);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOErrorWrap);
			urlLoader.load(urlRequest);
		}
		
		/**
		 * Returns the oauth token and secret so the application may store these values the
		 * next time the user logs into the application.
		 * */
		private function onAccessWrapToken(event:Event):void
		{	
			var urlvars:URLVariables = new URLVariables(String(event.target.data));
			
			this.oauth = new Oauth(urlvars.wrap_access_token, urlvars.wrap_refresh_token);
			
			resultsReceived.dispatch(this.oauth);
		}
		
		//---------------------------------------------------------//
		//-------------------  NETWORK METHODS---------------------/
		//--------------------------------------------------------//
		
		/**
		 * Retrieves a list of all networks and tokens for current user.
		 * The information is needed if you want to offer user option to switch
		 * multiple networks.
		 * 
		 * @return Array of <code>YammerNetwork</code> objects
		 * */
		public function getNetworks():void
		{
			var urlRequest:URLRequest = createRequest(YammerPaths.NETWORKS);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onNetworks);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Result handler for networks request.  Converts result object to
		 * <code>Array</code> object and dispatch a <code>YammerEvent.NETWORKS_REQUEST</code> event
		 * with the parsed object.
		 * 
		 * @private
		 * */
		private function onNetworks(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var networks:Array = YammerParser.parseNetworks(obj);
			
			resultsReceived.dispatch(networks);
		}
		
		/**
		 * Retrieves updated network info of all networks for current user.
		 * Information includes permalink, unseen message count, network name, id.
		 * This is useful for knowing the unseen message count for all networks.  
		 * 
		 * @return Array of <code>YammerNetworkCurrent</code> objects
		 * */
		public function getCurrentNetworks():void
		{
			var urlRequest:URLRequest = createRequest(YammerPaths.NETWORKS_CURRENT);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onCurrentNetworks);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Result handler for networks request.  Converts result object to
		 * <code>Array</code> object and dispatch a <code>YammerEvent.NETWORKS_CURRENT_REQUEST</code> event
		 * with the parsed object.
		 * 
		 * @private
		 * */
		private function onCurrentNetworks(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var networks:Array = YammerParser.parseNetworkCounts(obj);
			
			resultsReceived.dispatch(networks);
		}
		
	//---------------------------------------------------------//
	//-------------------  USER METHODS  ----------------------/
	//--------------------------------------------------------//

		/**
		 * Retrieve current user information.  The consumer key, consumer secret, oauth token 
		 * and oauth secret must all be set first to call this method.  Including the user, tags,
		 * and group memberships can result in a very large return file, so you have an option
		 * to exclude this data within the call by setting the flags to false. 
		 * 
		 * @param include_followed_users  Boolean flag to include followed users in return data
		 * @param include_followed_tags  Boolean flag to include followed tags in return data
		 * @param include_group_memberships  Boolean flag to include group memberships in return data (this flag doesn't seem to be working in API)
		 * 
		 * @return Array of <code>YammerCurrentUser</code>
		 */
		public function getCurrentUser(include_followed_users:Boolean = false, include_followed_tags:Boolean = false, include_group_memberships:Boolean = false):void 
		{
			var params:Object = new Object()
				if(include_followed_users) params.include_followed_users = include_followed_users;
				if(include_followed_tags) params.include_followed_tags = include_followed_tags;
				if(include_group_memberships) params.include_group_memberships = include_group_memberships;
			
			var user:YammerUser;
			var urlRequest:URLRequest = createRequest(YammerPaths.CURRENT_USER, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onCurrentUser);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Result handler for current user request.  Converts result object to
		 * <code>YammerUser</code> object and dispatch a <code>YammerEvent.CURRENT_USER</code> event
		 * with the parsed object.
		 * 
		 * @private
		 * */
		private function onCurrentUser(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var user:YammerUser = YammerParser.parseCurrentUser(obj);
		
			resultsReceived.dispatch(user);
		}
		
		
		/**
		 * Request for user from network.
		 * 
		 * @param user_id Id of user to retrieve
		 * 
		 * @return Array of <code>YammerUser</code>
		 * */
		public function getUsers(user_id:String):void
		{
			var path:String = YammerPaths.USERS + user_id + YammerPaths.JSON; 
			var urlRequest : URLRequest = createRequest(path);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleGetUser);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}	
		
		/**
		 * Result handler group request.  Converts result object to
		 * <code>YammerUser</code object and dispatch a <code>YammerEvent.USER_REQUEST_RESULTS</code>
		 * with the parsed object.
		 * 
		 * @private
		 * */
		private function handleGetUser(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var user:YammerUser = YammerParser.parseUser(obj);
		
			resultsReceived.dispatch(user);
		}
		
		/**
		 * Subscribe to user feed.  
		 * @param target_id The id of the user feed to subscribe to
		 * @param is_suggestion Boolean flag indicating this user was suggested to you
		 * */
		public function followUser(target_id:String, is_suggestion:Boolean = false):void
		{
			var path:String = YammerPaths.SUBSCRIPTIONS;
			var params:Object = new Object();
				params.target_type = YammerTypes.USER_TYPE;
				params.target_id = target_id;
			
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
				
			var urlRequest : URLRequest = createRequest(path, params, URLRequestMethod.POST);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Unubscribe from user feed.
		 * @param target_id The id of the user to subscribe to
		 * */
		public function unfollowUser(target_id:String):void
		{
			var path:String = YammerPaths.SUBSCRIPTIONS;
			var params:Object = new Object();
				params.target_type = YammerTypes.USER_TYPE; // double check this might not have first letter capitalized
				params.target_id = target_id;
			
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
			
			var urlRequest : URLRequest = createRequest(path, params, "DELETE"); // URLRequestMethod.DELETE only in AIR
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Check following status. If status is true, returns a 200 response. If status is false, returns 404.
		 * @param user_id The user id
		 */				
		public function isFollowingUser(user_id:Number):void 
		{	
			var params:Object = new Object();
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
			
			var path:String = YammerPaths.SUBSCRIPTIONS +  YammerPaths.TO_USER + user_id + ".json";
			var urlRequest : URLRequest = createRequest(path, params, URLRequestMethod.POST);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}	
		
		
	//------------------------------------------------------------------//
	//----------------------- MESSAGE METHODS  -------------------------/
	//-----------------------------------------------------------------//
		

		/**
		 * Generic shortcut request for messages. Messages are always delivered 20 messages at a time.
		 * You can request messages newer than or older than an id with the "newer_than" and "older_than" params.
		 * This method is usually used for Yammer Tab objects as they do not have an ID (sent, all, received, favorites, rss, my feed)
		 *
		 * @param url path for the <code>YammerTab</code> object
		 * @param older_than Return only messages older than the message id specified 
		 * @param new_than Return only messages newer than the message ud specified.
		 * @param threaded Flag to return only the first message in each thread
		 * @param update_last_seen_message_id Boolean value to set if users have seen messages prior to last seen message id 
		 * */
		public function getMessages(path:String, newer_than:String = null, older_than:String = null, threaded:Boolean = false, update_last_seen_message_id:Boolean = false):void	
		{
			path = path + YammerPaths.JSON; // json
			var params:Object = new Object();
			if(older_than) params.older_than = older_than;
			if(newer_than) params.newer_than = newer_than;
			if(threaded) params.threaded = threaded;
			if(update_last_seen_message_id) params.update_last_seen_message_id = update_last_seen_message_id;
		 
			var urlRequest : URLRequest = createRequest(path, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, messageListHandler);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}	
		
		/**
		 * Request for group messages. Messages are always delivered 20 messages at a time.
		 * You can request messages newer than or older than an id with the "newer_than" and "older_than" params.
		 * This method is usually used for Yammer Tab objects as they do not have an ID (sent, all, received, favorites, rss, my feed)
		 *
		 * @param id The id for the <code>YammerGroup</code> object
		 * @param older_than Return only messages older than the message id specified 
		 * @param new_than Return only messages newer than the message ud specified.
		 * @param threaded Flag to return only the first message in each thread
		 * @param update_last_seen_message_id Boolean value to set if users have seen messages prior to last seen message id 
		 * */
		public function getGroupMessages(id:String, newer_than:String = null, older_than:String = null, threaded:Boolean = false, update_last_seen_message_id:Boolean = false):void	
		{			
			var path:String = YammerPaths.MESSAGES + YammerPaths.MESSAGES_IN_GROUP + id + YammerPaths.JSON; // json
			var params:Object = new Object();
			
			if(older_than) params.older_than = older_than;
			if(newer_than) params.newer_than = newer_than;
			if(threaded) params.threaded = threaded;
			if(update_last_seen_message_id) params.update_last_seen_message_id = update_last_seen_message_id;
			
			var urlRequest : URLRequest = createRequest(path, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, messageListHandler);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Request for user messages. Messages are always delivered 20 messages at a time.
		 * You can request messages newer than or older than an id with the "newer_than" and "older_than" params.
		 * This method is usually used for Yammer Tab objects as they do not have an ID (sent, all, received, favorites, rss, my feed)
		 *
		 * @param id The id for the <code>YammerUser</code> object
		 * @param older_than Return only messages older than the message id specified 
		 * @param new_than Return only messages newer than the message ud specified.
		 * @param threaded Flag to return only the first message in each thread
		 * @param update_last_seen_message_id Boolean value to set if users have seen messages prior to last seen message id 
		 * */
		public function getUserMessages(id:String, newer_than:String = null, older_than:String = null, threaded:Boolean = false, update_last_seen_message_id:Boolean = false):void	
		{	
			var path:String = YammerPaths.MESSAGES + YammerPaths.MESSAGES_FROM_USER + id + YammerPaths.JSON; // json
			var params:Object = new Object();
			
			if(older_than) params.older_than = older_than;
			if(newer_than) params.newer_than = newer_than;
			if(threaded) params.threaded = threaded;
			if(update_last_seen_message_id) params.update_last_seen_message_id = update_last_seen_message_id;
			
			var urlRequest : URLRequest = createRequest(path, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, messageListHandler);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Request for tag messages. Messages are always delivered 20 messages at a time.
		 * You can request messages newer than or older than an id with the "newer_than" and "older_than" params.
		 * This method is usually used for Yammer Tab objects as they do not have an ID (sent, all, received, favorites, rss, my feed)
		 *
		 * @param id The id for the <code>YammerUser</code> object
		 * @param older_than Return only messages older than the message id specified 
		 * @param new_than Return only messages newer than the message ud specified.
		 * @param threaded Flag to return only the first message in each thread
		 * @param update_last_seen_message_id Boolean value to set if users have seen messages prior to last seen message id 
		 * */
		public function getTagMessages(id:String, newer_than:String = null, older_than:String = null, threaded:Boolean = false, update_last_seen_message_id:Boolean = false):void	
		{			
			var path:String = YammerPaths.MESSAGES + YammerPaths.MESSAGES_TAGGED_WITH + id + YammerPaths.JSON; // json
			var params:Object = new Object();
			
			if(older_than) params.older_than = older_than;
			if(newer_than) params.newer_than = newer_than;
			if(threaded) params.threaded = threaded;
			if(update_last_seen_message_id) params.update_last_seen_message_id = update_last_seen_message_id;
			
			var urlRequest : URLRequest = createRequest(path, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, messageListHandler);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Request for bot messages. Messages are always delivered 20 messages at a time.
		 * You can request messages newer than or older than an id with the "newer_than" and "older_than" params.
		 * This method is usually used for Yammer Tab objects as they do not have an ID (sent, all, received, favorites, rss, my feed)
		 *
		 * @param id The id for the <code>YammerUser</code> (bot) object
		 * @param older_than Return only messages older than the message id specified 
		 * @param new_than Return only messages newer than the message ud specified.
		 * @param threaded Flag to return only the first message in each thread
		 * @param update_last_seen_message_id Boolean value to set if users have seen messages prior to last seen message id 
		 * */
		public function getBotMessages(id:String, newer_than:String = null, older_than:String = null, threaded:Boolean = false, update_last_seen_message_id:Boolean = false):void	
		{			
			var path:String = YammerPaths.MESSAGES + YammerPaths.MESSAGES_FROM_BOT + id + YammerPaths.JSON; // json
			var params:Object = new Object();
			
			if(older_than) params.older_than = older_than;
			if(newer_than) params.newer_than = newer_than;
			if(threaded) params.threaded = threaded;
			if(update_last_seen_message_id) params.update_last_seen_message_id = update_last_seen_message_id;
			
			var urlRequest : URLRequest = createRequest(path, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, messageListHandler);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Request for thread messages. Messages are always delivered 20 messages at a time.
		 * You can request messages newer than or older than an id with the "newer_than" and "older_than" params.
		 * This method is usually used for Yammer Tab objects as they do not have an ID (sent, all, received, favorites, rss, my feed)
		 *
		 * @param id The id for the <code>YammerThread</code> object
		 * @param older_than Return only messages older than the message id specified 
		 * @param new_than Return only messages newer than the message ud specified.
		 * @param threaded Flag to return only the first message in each thread
		 * @param update_last_seen_message_id Boolean value to set if users have seen messages prior to last seen message id 
		 * */
		public function getThreadMessages(id:String, newer_than:String = null, older_than:String = null, threaded:Boolean = false, update_last_seen_message_id:Boolean = false):void	
		{			
			var path:String = YammerPaths.MESSAGES + YammerPaths.MESSAGES_IN_THREAD + id + YammerPaths.JSON; // json
			var params:Object = new Object();
			
			if(older_than) params.older_than = older_than;
			if(newer_than) params.newer_than = newer_than;
			if(threaded) params.threaded = threaded;
			if(update_last_seen_message_id) params.update_last_seen_message_id = update_last_seen_message_id;
			
			var urlRequest : URLRequest = createRequest(path, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, messageListHandler);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}

		/**
		 * Post a message. This is a shortcut method that formats the body and replied_to_id
		 * into a params object and sends a properly formatted request to the API.
		 *
		 * @param body message to post.
		 * @param replied_to_id if user is replying to a message, include the original message's id.
		 * @param group_id if user is posting message to a group
		 * @param files array of bitmap data for files to attach to message
		 * @param direct_to_id if user is sending a message directly to another user. 
		 * */
		public function postMessage(body:String, replied_to_id:String = null, group_id:String = null, direct_to_id:String = null, files:Array = null):void 
		{
			var path:String = YammerPaths.POST_MESSAGE;
			var params:Object = new Object();
				params.body = body;
				
			if (replied_to_id) { params.replied_to_id = replied_to_id; }
			if (group_id) { params.group_id = group_id; }
			if (direct_to_id) { params.direct_to_id = direct_to_id; }
			
			var urlRequest : URLRequest = createRequest(path, params, URLRequestMethod.POST);
			
			// attach any files
			if( files && files.length > 0) {
				var convertedFiles:Array = files.map( createFileObject );
				urlRequest.contentType = 'multipart/form-data; boundary=' + MultipartFormHelper.getBoundary();
				urlRequest.data = MultipartFormHelper.getPostData( convertedFiles, params );
				convertedFiles = null;
			} 
			
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, messageListHandler);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
			
			return;
		}
		
		private function createFileObject(file:FileReference, ...rest):Object 
		{
			var isImage:Boolean = FileUtils.isImage(FileUtils.fileExtension(file.name));
			return {"name": file.name, "bytes":file.data, "image":isImage}		
		}

		
		/**
		 * Like a <code>YammerMessage</code>.
		 * @param message_id The id of the message to like
		 * */
		public function likeMessage(message_id:String):void 
		{
			var path:String = YammerPaths.LIKED + "current" + YammerPaths.JSON; 

			var params:Object = new Object();
				params.message_id = message_id;	
			
			var urlRequest : URLRequest = createRequest(path, params, URLRequestMethod.POST)
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Remove a <code>YammerMessage</code> from likes.
		 * @param message_id The id of the message to remove from likes
		 * */
		public function unlikeMessage(message_id:String):void 
		{
			var path:String = YammerPaths.LIKED + "current" + YammerPaths.JSON; 
			
			var params:Object = new Object();
				params.message_id = message_id;	
			
			var urlRequest : URLRequest = createRequest(path, params, "DELETE")
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Result handler for message list request.  Convert result object to
		 * <code>YammerMessageList</code object and dispatch a <code>YammerEvent.MESSAGES_REQUEST_RESULTS</code> 
		 * event with the parsed object.
		 * 
		 * @private
		 * */
		private function messageListHandler(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var messageList:YammerMessageList = YammerParser.parseMessages( obj );
			
			resultsReceived.dispatch(messageList);
		}
		
		
	//------------------------------------------------------------------//
	//------------------------  GROUP METHODS  --------------------------/
	//-----------------------------------------------------------------//
		
		/**
		 * Request for <code>YammerGroup</code>.
		 * 
		 * @param path The url path for the <code>YammerGroup</code> object
		 * 
		 * @return <code>YammerGroup</code>
		 * */
		public function getGroup(group_id:String):void	
		{			
			var path:String = YammerPaths.GROUPS + group_id + YammerPaths.JSON; // json

			var urlRequest : URLRequest = createRequest(path);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleGetGroup);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Result handler group request.  Converts result object to
		 * <code>YammerGroup</code object and dispatch a <code>YammerEvent</code>
		 * with the parsed object.
		 * 
		 * @private
		 * */
		private function handleGetGroup(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var group:YammerGroup = YammerParser.parseGroup(obj);
			
			resultsReceived.dispatch(group);
		}
		
		/**
		 * Join <code>YammerGroup</code>.
		 * 
		 * @param group_id The id of the <code>YammerGroup</code> to join
		 * */
		public function joinGroup(group_id:String):void
		{
			var path:String = YammerPaths.GROUP_MEMBERSHIPS;
			var params:Object = new Object();
				params.group_id = group_id;
			
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
			
			var urlRequest : URLRequest = createRequest(path, params, URLRequestMethod.POST);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Leave <code>YammerGroup</code>.
		 * 
		 * @param group_id The id of the <code>YammerGroup> to leave
		 * */
		public function leaveGroup(group_id:String):void
		{
			var path:String = YammerPaths.GROUP_MEMBERSHIPS;
			var params:Object = new Object();
				params.group_id = group_id;
				
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
			
			var urlRequest : URLRequest = createRequest(path, params, "DELETE");
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		
	//------------------------------------------------------------------//
	//------------------------  TAG METHODS  ---------------------------/
	//-----------------------------------------------------------------//
		
		/**
		 * Request for tag.
		 * @param path The url path for the <code>YammerTag</code> object
		 * 
		 * @return <code>YammerTag</code>
		 * */
		public function getTag(tag_id:String):void	
		{			
			var path:String = YammerPaths.TAGS + tag_id + YammerPaths.JSON; // json
			
			var urlRequest : URLRequest = createRequest(path);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleGetTag);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Result handler tag request.  Converts result object to
		 * <code>YammerTag</code object and dispatch a <code>YammerEvent</code>
		 * with the parsed object.
		 * 
		 * @private
		 * */
		private function handleGetTag(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var tag:YammerTag = YammerFactory.tag( obj );
			
			resultsReceived.dispatch(tag);
		}
		
		/**
		 * Subscribe to tag feed.
		 * @param target_id The id of the tag to subscribe to
		 * */
		public function followTag(target_id:String):void
		{
			var path:String = YammerPaths.SUBSCRIPTIONS;
			var params:Object = new Object();
				params.target_type = YammerTypes.TAG_TYPE;
				params.target_id = target_id;
			
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
			
			var urlRequest : URLRequest = createRequest(path, params, URLRequestMethod.POST);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Unubscribe from tag feed.
		 * @param target_id The id of the tag to subscribe to
		 * */
		public function unfollowTag(target_id:String):void
		{
			var path:String = YammerPaths.SUBSCRIPTIONS;
			var params:Object = new Object();
				params.target_type = YammerTypes.TAG_TYPE;
				params.target_id = target_id;
			
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
			
			var urlRequest : URLRequest = createRequest(path, params, "DELETE"); // URLRequestMethod.DELETE only in AIR
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		
		/**
		 * Whether user is following a tag. Returns 200 for true, 404 for false.
		 * @param tag_id id assigned to tag
		 * */
		public function isFollowingTag(tag_id:Number):void 
		{
			var path:String = YammerPaths.SUBSCRIPTIONS + "to_tag/" + tag_id + ".json";
			var params:Object = new Object();

			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
			
			var urlRequest : URLRequest = createRequest(path, params, URLRequestMethod.POST);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
	//------------------------------------------------------------------//
	//------------------------  RSS METHODS  ---------------------------/
	//-----------------------------------------------------------------//
		
		/**
		 * Subscribe to rss (bot) feed.  
		 * @param target_id The id of the rss (bot) feed to subscribe to
		 * */
		public function followRSS(target_id:String):void
		{
			var path:String = YammerPaths.SUBSCRIPTIONS;
			var params:Object = new Object();
				params.target_type = YammerTypes.BOT_TYPE;
				params.target_id = target_id;
			
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
			
			var urlRequest : URLRequest = createRequest(path, params, URLRequestMethod.POST);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Unubscribe from  rss (bot) feed.
		 * @param target_id The id of the  rss (bot) to subscribe to
		 * */
		public function unfollowRSS(target_id:String):void
		{
			var path:String = YammerPaths.SUBSCRIPTIONS;
			var params:Object = new Object();
				params.target_type = YammerTypes.BOT_TYPE; // double check this might not have first letter capitalized
				params.target_id = target_id;
			
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
			
			var urlRequest : URLRequest = createRequest(path, params, "DELETE"); // URLRequestMethod.DELETE only in AIR
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		
		//------------------------------------------------------------------//
		//-----------------------  SUGGESTIONS METHODS  -------------------------/
		//-----------------------------------------------------------------//
		
		/**
		 * Top looks for "hot" suggestions we'll display for the user.
		 * 
		 * @param type Yammer suggestions types (user or group).
		 * 
		 * @return Array of <code>YammerSuggestion</code> objects
		 * */ 
		public function getSuggestions(type:String = null, top:Boolean = false):void 
		{ 
			var path:String = YammerPaths.SUGGESTIONS;
			if (type == YammerTypes.GROUPS_TYPE) { path += YammerTypes.GROUPS_TYPE; }
			if (type == YammerTypes.USERS_TYPE) { path += ""; }
			var params:Object = {};
			if (top) { params.top = 1; }
			
			var urlRequest : URLRequest = createRequest(path, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleGetSuggestions);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}   
		
		private function handleGetSuggestions(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var suggestions:Array = YammerParser.parseSuggestions(obj);
			
			resultsReceived.dispatch(suggestions);
	
			obj = null;
			suggestions = null;
		}
		
		/**
		 * Decline a specific suggestion.
		 * @param suggestion_id Id of suggestion to decline
		 * */
		public function declineSuggestion(suggestion_id:String):void 
		{
			var path:String = YammerPaths.SUGGESTIONS + suggestion_id + ".json";
			var params:Object = new Object();
				params.id = suggestion_id;	   
				
			if(!this.airClient) params.no_201 = true; // needed for web-based application because 201 is not handled
				
			var urlRequest : URLRequest = createRequest(path, params, "DELETE");
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); 
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}       
		
		/**
		 * Gets a list of Yammer requests to join groups.
		 * 
		 * @return Array of <code>YammerRequest</code> objects
		 * */
		public function getRequests():void 
		{
			var path:String = YammerPaths.REQUESTS;
			var urlRequest : URLRequest = createRequest(path);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleGetRequests); 
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		public function handleGetRequests(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);
			var requests:Array = YammerParser.parseRequests(obj);
			
			resultsReceived.dispatch(requests);
			
			obj = null;
			requests = null;
		}
		
	//------------------------------------------------------------------//
	//-----------------------  SEARCH METHODS  -------------------------/
	//-----------------------------------------------------------------//
		
		/**
		 * Search for Yammer content. The search resource will return a list of messages, users, tags and groups that match the user's search query. 
		 * Only 20 results of each type will be returned for each page, but a total count is returned with each query. 
		 * page=1 (the default) will return items 1-20, page=2 will return items 21-30, etc. 
		 * 
		 * @param search The search query
		 * @param page The number for the page to return
		 * 
		 * @return Array of <code>YammerSearch</code> objects
		*/
		public function searchResource(search:String, page:Number = 1):void
		{
			this.searchTerm = search; // store this to return with results
			var path:String = YammerPaths.SEARCH;
			var params:Object = new Object();
			if(search) params.search = search;
			if(page) params.page = page;
			
			var urlRequest : URLRequest = createRequest(path, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleSearchResource);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		private function handleSearchResource(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var search:YammerSearch = YammerParser.parseSearch( obj );
				search.search_term = this.searchTerm;
				
			resultsReceived.dispatch(search);
				
			obj = null;
			search = null;
		}
		
		/**
		 * Auto-complete text search returns tags, users, groups matching search text.
		 * 
		 * @param search_for The text to search for.
		 * 
		 * @return Array of <code>YammerUser</code>, <code>YammerGroup</code>, <code>YammerTags</code> objects
		 * */
		public function autoCompleteSearch(search_for:String):void 
		{
			var path:String = YammerPaths.TYPEAHEAD;
			var params:Object = new Object();
				params.prefix = search_for;	
	
			var urlRequest : URLRequest = createRequest(path, params);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleSearchResource);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}   
		
		private function handleAutoCompleteSearch(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var tags:Array = YammerParser.parseTagSearch(obj);
			var groups:Array = YammerParser.parseGroupSearch(obj);
			var users:Array = YammerParser.parseUserSearch(obj);
			var matches:Array = users.concat(tags, groups);
			
			resultsReceived.dispatch(matches);
	
			obj = null;
			tags = null;
			groups = null;
			users = null;
			matches = null;
		}
		
	//--------------------------------------------------------//
	//------------------  EVENT HANDLERS  --------------------/
	//-------------------------------------------------------//
		
		/**
		 * Request complete event handler used for call only returning 200 or 201 status.
		 * */
		private function handleRequestComplete(event:Event):void
		{
			//dispatchEvent(new YammerEvent(YammerEvent.REQUEST_COMPLETE));
			
			this.resultsReceived.dispatch();
		}
		
		/**
		 * Handle security errors.
		 * @private
		 * */
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			var error:YammerError = new YammerError();
				error.errorMessage = event.text;
				error.errorCode = YammerErrorTypes.SECURITY_ERROR;

			errorReceived.dispatch(error);
		}
		
		/**
		 * Handle io errors. Some errors will return valid xml code that can be parsed for
		 * the error message.  Examples of returned xml:
		 * 
		 * 	<errors> 
		 * 		<error>Conversation Invalid recipient for direct message.</error> 
		 * 	</errors>
		 * 
		 * 	{"response":{"code":16,"message":"Token not found.","stat":"fail"}}
		 * 
		 * @private
		 * */
		private function handleIOError(event:IOErrorEvent):void
		{
			var error:YammerError = new YammerError();
				error.erroEvent = event;
			
			trace("Yammer :: handleIOError data: " + String(event.target.data));
			trace("Yammer :: handleIOError text: " + event.text);
			
			try{
				var obj:Object = JSON.decode(String(event.target.data)) as Object;
				
				if(obj.response) {
					error.errorCode = obj.response.code;
					error.errorMessage = obj.response.message;	

				} else {
					error.errorCode = YammerErrorTypes.UNKNOWN_ERROR;
					error.errorMessage = YammerError.getErrorMessage(error.errorCode) +  "You may want to check the http status event.";
					error.errorDetail = event.text;
				}
			} catch (e:Error) {
				error.errorCode = YammerErrorTypes.UNKNOWN_ERROR;
				error.errorMessage = YammerError.getErrorMessage(error.errorCode) + "You may want to check the http status event.";
				error.errorDetail = event.text;
			}
			
			errorReceived.dispatch(error);
		}
		
		/**
		 * Handle http status.
		 * @private
		 * */
		private function handleHTTPStatus(event:HTTPStatusEvent):void
		{
			//trace("YammerRequest :: handleHTTPStatus: " + event.status);
			
			var error:YammerError = new YammerError();
			if(event.status == 503 || event.status == 0) {
				error.errorCode = YammerErrorTypes.NO_NETWORK_CONNECTION;
				error.errorMessage = YammerError.getErrorMessage(YammerErrorTypes.NO_NETWORK_CONNECTION);
				errorReceived.dispatch(error);
			} else if (event.status >= 400) {
				this.httpStatusUpdated.dispatch(event.status);
			} else {
				this.httpStatusUpdated.dispatch(event.status);
			}
		}
		
		/**
		 * If we get an error when calling the wrap oauth, the Yammer service
		 * only returns http status respone and simple message.  I guess we 
		 * could make a special HTTP status handler for this.
		 * 
		 * 401 Unauthorized, the username or password is invalid or the network is disable
		 * 403 Forbidden, has two interpretations: (1) The users network uses Single-Sign-On, 
		 * the user most likely needs to generate an ephemeral password. (2) The username 
		 * and ephemeral password they're using is invalid. 
		 * 500 Internal Server Error, the service is not reachable
		 * */
		private function handleIOErrorWrap(event:IOErrorEvent):void
		{
			var error:YammerError = new YammerError();
				error.erroEvent = event;
				error.errorDetail = event.target.data;
				
			if(event.target.data == "Unauthorized"){
				error.errorCode = YammerErrorTypes.UNAUTHORIZED_STATUS;
				error.errorMessage = YammerError.getErrorMessage(error.errorCode);
			} else if (event.target.data == "Forbidden") {
				error.errorCode = YammerErrorTypes.FORBIDDEN_STATUS;
				error.errorMessage = YammerError.getErrorMessage(error.errorCode);
			} else if (event.target.data == "Internal Server Error") {
				error.errorCode = YammerErrorTypes.INTERNAL_SERVER_ERROR;
				error.errorMessage = YammerError.getErrorMessage(error.errorCode);
			}
			
			trace("YammerRequest :: handleIOErrorWrap: " + event.target.data);
	
			errorReceived.dispatch(error);
		}
		
		/**
		 * If we get an error when calling a non-api method (like oauth), the Yammer service
		 * only returns XML, no JSON option. Here is an example response:
		 * 
		 * <hash>
		 * 	<response>
		 * 		<code>22</code>
		 * 		<message>Unsupported signature method.</message>
		 * 		<stat>fail</stat>
		 * 	</response>
		 * </hash>
		 * */
		private function handleIOErrorXML(event:IOErrorEvent):void
		{
			var error:YammerError = new YammerError();
			error.erroEvent = event;
			
			trace("YammerRequest :: handleIOError: " + String(event.target.data));
			trace("YammerRequest :: handleIOError: " + event.text);
			
			try{
				var xml:XML = XML(xml['response']);
				
				if(xml){
					error.errorMessage = xml['response']['message'];
					error.errorCode = xml['response']['code'];	
				} else {
					error.errorCode = YammerErrorTypes.UNKNOWN_ERROR;
					error.errorMessage = event.text;
				}
			} catch (e:Error) {
				
				error.errorCode = YammerErrorTypes.UNKNOWN_ERROR;
				error.errorMessage = event.text + " You may want to check the http status event.";
			}
			
			//dispatchEvent(new YammerEvent(YammerEvent.REQUEST_FAIL, null, null, error));
			errorReceived.dispatch(error);
		}
	
	
	//--------------------------------------------------------//
	//----------------  PRIVATE METHODS  ---------------------/
	//-------------------------------------------------------//
		
		/**
		 * Helper function to create URLRequets for the Yammer API service.
		 * 
		 * @param path The REST URL
		 * @param params The data to pass on the request to the method
		 * @param method The URLRequest method (GET/PUT/DELETE)
		 * @return URLRequest
		 * @private
		 */
		private function createRequest(path:String, params:Object = null, method:String = "GET"):URLRequest 
		{
			var urlRequest:URLRequest = new URLRequest();
				urlRequest.url = path;
			
			// DELETE AND PUT are supported only in AIR projects, these fail silently for AS3 projects
			if ((method == "DELETE") || (method == "PUT")) { 
				if(params) params._method = method;
				method = URLRequestMethod.POST;
			} else if (!airClient && method == URLRequestMethod.GET) { //Workaround for Adobe weirdness. Custom headers aren't passed in GET requests. We need to send a POST with at least one param.  
				if(params) params._method = URLRequestMethod.GET;
				method = URLRequestMethod.POST;
			} 
			
			// assign method
			urlRequest.method = method; 
			
			// assign data parameters
			if(params){
				var paramStr:String = urlEncodeParams(params);
				if (paramStr) { urlRequest.data = paramStr; } 
			}
			
			// set the headers and dump the cookies (AIR only) 
			if(this.airClient) {
				urlRequest.requestHeaders = new Array( new URLRequestHeader("Authorization", createOauthHeader()), new URLRequestHeader("Cookie", "")  );	
			} else {
				urlRequest.requestHeaders = new Array( new URLRequestHeader("Authorization", createOauthHeader()) );	
			}
			
			// remove oauth_verify after used for authentication
			if(this.oauthVerifier) {
				this.oauthVerifier = null;
			}
			
			return urlRequest;			
		}
		
		
		/**
		 * Create the Oath heders for each request.
		 * Author: Andrew Arrow, Michael RItchie copyright Yammer, Inc, 2009
		 * 
		 * @param token OAuthToken value
		 * @return String value for request header
		 * @private
		 * */
		private function createOauthHeader():String
		{
			var header:String = "";
				header += "OAuth realm=\"";
				header += "\", oauth_consumer_key=\"";
				header += this.consumerKey;
				header += "\", ";
			
			if(this.oauth.oauth_token != null) {
				header += "oauth_token=\"";
				header += this.oauth.oauth_token;
				header += "\", ";
			}
			
		    header += ("oauth_signature_method=\"");
		    header += ("PLAINTEXT");
		    header += ("\", oauth_signature=\"");
		    header += (this.consumerSecret);
		    header += ("%26");
		    
		    if (this.oauth.oauth_token_secret != null) {
		      	header += (this.oauth.oauth_token_secret);
		    }
		    
		    var date:Date = new Date();
			var uuid:Number = date.getTime();
		 
		    header += ("\", oauth_timestamp=\"");
		    header += (uuid + "" );
		    header += ("\", oauth_nonce=\"");
		    header += (uuid + "");
		
		    if (this.oauthVerifier != null) {
		      header += ("\", ");
		      header += ("oauth_verifier=\"");
		      header += (this.oauthVerifier);
		    }
		
		    header += ("\", oauth_version=\"1.0\"");
			
			//trace ("Header: " + header);
			
		    return header;
		}

		/**
		 * URLEncode the parameters for the URLRequest data.
		 * @params Object parameters
		 * @private
		 * */
		private function urlEncodeParams(params:Object):String 
		{
			var str:String = "";
			for (var param_name:String in params) {
				str += encodeURIComponent(param_name) + "=" + encodeURIComponent(params[param_name]) + "&"; 
			}
			return str.substring(0, str.length-1);		
		}
	}
}
