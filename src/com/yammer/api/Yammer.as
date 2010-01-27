/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api
{ 
	import com.adobe.serialization.json.JSON;
	import com.yammer.api.events.YammerEvent;
	import com.yammer.api.utils.FileUtils;
	import com.yammer.api.utils.MultipartFormHelper;
	import com.yammer.api.utils.YammerFactory;
	import com.yammer.api.utils.YammerParser;
	import com.yammer.api.vo.YammerGroup;
	import com.yammer.api.vo.YammerMessageList;
	import com.yammer.api.vo.YammerSearch;
	import com.yammer.api.vo.YammerTag;
	import com.yammer.api.vo.YammerTypes;
	import com.yammer.api.vo.YammerUser;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
	
	
	/**
	* 	Broadcast when results have been loaded from requestToken() call.
	*
	* 	The event contains the following resultObject properties		
	* 	data.oauth_token and data.oauth_token_secret. 	
	* 
	* 	@eventType com.yammer.api.events.YammerEvent.REQUEST_TOKEN
	* 
	*/
	[Event(name="requestToken", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	* 	Broadcast when results have been loaded from accessToken() call.
	*
	* 	The event contains the following resultObject properties		
	* 	data.oauth_token and data.oauth_token_secret.	
	* 
	* 	@eventType com.yammer.api.events.YammerEvent.ACCESS_TOKEN
	* 
	*/
	[Event(name="accessToken", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when request fails.
	 *
	 * 	@eventType com.yammer.api.events.YammerEvent.REQUEST_FAIL
	 * 
	 */
	[Event(name="requestFail", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when request completes (usually 200 or 201 status).
	 *
	 * 	@eventType com.yammer.api.events.YammerEvent.REQUEST_COMPLETE
	 * 
	 */
	[Event(name="requestComplete", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when on httpStatus event
	 *
	 * 	@eventType com.yammer.api.events.YammerEvent.HTTP_STATUS
	 * 
	 */
	[Event(name="httpStatus", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when on ioError event
	 *
	 * 	@eventType com.yammer.api.events.YammerEvent.IO_ERROR
	 * 
	 */
	[Event(name="ioError", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when on securityError event
	 *
	 * 	@eventType com.yammer.api.events.YammerEvent.SECURITY_ERROR
	 * 
	 */
	[Event(name="securityError", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast file progress events.
	 * 
	 * 	The event contains the following resultObject properties		
	 * 	bytes.
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.PROGRESS
	 * 
	 */
	[Event(name="progress", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	* 	Broadcast when results have been loaded from getCurrentUser().
	*
	* 	The event contains the following resultObject properties		
	* 	data.user. An YammerUser object.	
	* 
	* 	@eventType com.yammer.api.events.YammerEvent.CURRENT_USER
	* 
	*/
	[Event(name="currentUser", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when results have been loaded from getNetworks().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.networks. An array of YammerNetwork objects.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.NETWORKS_REQUEST
	 * 
	 */
	[Event(name="networksRequest", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when results have been loaded from getCurrentNetworks().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.networks. An array of YammerNetworkCurrent objects.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.NETWORKS_CURRENT_REQUEST
	 * 
	 */
	[Event(name="networksCurrentRequest", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when results have been loaded from getMessages().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.messages. An array of YammerMessage objects.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.MESSAGES_REQUEST_RESULTS
	 * 
	 */
	[Event(name="messagesRequestResults", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when results have been loaded from getGroup().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.group. An array of YammerMessage objects.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.GROUP_REQUEST_RESULTS
	 * 
	 */
	[Event(name="groupRequestResults", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when results have been loaded from getUser().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.user. A YammerUser object.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.USER_REQUEST_RESULTS
	 * 
	 */
	[Event(name="userRequestResults", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when results have been loaded from getTag().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.tag. A YammerTag object.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.TAG_REQUEST_RESULTS
	 * 
	 */
	[Event(name="tagRequestResults", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when results have been loaded from getRSS().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.rss. A YammerUser object.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.RSS_REQUEST_RESULTS
	 * 
	 */
	[Event(name="rssRequestResults", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when results have been loaded from searchResources().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.search. A YammerSearch object.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.SEARCH_REQUEST_RESULTS
	 * 
	 */
	[Event(name="searchRequestResults", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when results have been loaded from autoCompleteSearch().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.matches. An array of YammerTag, YammerUser, YammerGroup objects.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.AUTO_COMPLETE_RESULTS
	 * 
	 */
	[Event(name="autoCompleteResults", type="com.yammer.api.events.YammerEvent")]
	
	
	/**
	 * 	Broadcast when results have been loaded from getSuggestions().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.suggestions. An array of YammerSuggestions objects.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.SUGGESTIONS_RESULTS
	 * 
	 */
	[Event(name="suggestionsResults", type="com.yammer.api.events.YammerEvent")]
	

	/**
	 * 	Broadcast when results have been loaded from getRequests().
	 *
	 * 	The event contains the following resultObject properties		
	 * 	data.requests. An array of YammerRequest objects.	
	 * 
	 * 	@eventType com.yammer.api.events.YammerEvent.REQUESTS_RESULTS
	 * 
	 */
	[Event(name="requestsResult", type="com.yammer.api.events.YammerEvent")]
	
	
	
	public class Yammer extends EventDispatcher	
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
		protected var oauthRequestToken:String;
		
		/**
		 * @private
		 */
		protected var oauthRequestSecret:String;
		
		/**
		 * @private
		 */
		protected var oauthTokenSecret:String;
		
		/**
		 * @private
		 */
		protected var oauthToken:String;
		
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
		 * Yammer library handles connecting to the Yammer API (https://www.yammer.com/api_doc.html). 
		 * The initialize method allows you to authenticate requests by passing the user's credentials
		 * and sign requests by passing your application's credentials.
		 *
		 * <p>Here's an example of authorizing the Yammer service and doing the OAuth dance.  
		 * Please note you will need your own consumer key and secret for the Yammer API available at:
		 * https://www.yammer.com/yammerdevelopersnetwork/client_applications/new </p>
		 * 
		 * <p>A YammerRequest will dispatch the following service events.  For additional events @see <code>YammerEvent</code>.: 
		 * 	REQUEST_COMPLETE
		 * 	REQUEST_FAIL
		 * 	REQUEST_TOKEN
		 * 	ACCESS_TOKEN
		 * 	CURRENT_USER
		 * 	MESSAGES_REQUEST_RESULTS
		 * 	</p>
		 *
		 * <listing>
		 * import com.yammer.api.Yammer;
		 * import com.yammer.api.YammerEvent;
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
		 * 		
		 * 		if(oauthToken && oauthSecret) { 
		 * 			// we previously authorized app and set the values in the service using stored oauth values
		 * 			service.setOuthTokens(oauthToken, oauthSecret);
		 * 		} else { 
		 * 			// first time to authorize app and so we do the aouth dance
		 * 			service.requestToken(); 
		 * 			service.addEventListener(YammerEvent.REQUEST_TOKEN, requestTokenHandler);
		 * 			service.addEventListener(YammerEvent.REQUEST_FAIL, requestFailureHandler);
		 * 		}
		 * }
		 *
		 * //Handle request token event, returns request token and secret. 
		 * private function requestTokenHandler(event:YammerEvent):void {
		 * 		service.removeEventListener(YammerEvent.REQUEST_TOKEN, requestTokenHandler);
		 *		service.sendAuthorizationRequest(); // open browser window to autorize application and get verify pin
		 * }
		 * 
		 * //Users must manually copy and enter the verify pin from the request authorization browser page
		 * private function requestAccessToken(verify_pin:String):void {
		 *  	service.addEventListener(YammerEvent.ACCESS_TOKEN, accessTokenHandler);
		 * 		service.accessToken(verify_pin);
		 * }
		 * 
		 * //Handle access token event, returns access token and secret. 
		 * private function accessTokenHandler(event:YammerEvent):void {
		 * 		service.removeEventListener(YammerEvent.ACCESS_TOKEN, accessTokenHandler);
		 * 		
		 * 		// You may want to store these values in SO or local store so you can set have next time application is run
		 *		oauthToken = String(event.data.oauth_token);
		 *		oauthSecret = String(event.data.oauth_token_secret);
		 * }
		 *
		 * // Send request for current user
		 * private function getCurrentUser():void {
		 * 		service.addEventListener(YammerEvent.CURRENT_USER, currentUserHandler);
		 * 		service.getCurrentUser();
		 * }
		 * 
		 * // The user is returned as a YammerUser object
		 * private function currentUserHandler(event:YammerEvent):void
		 * {
		 * 		service.removeEventListener(YammerEvent.CURRENT_USER, currentUserHandler);
		 * 		var user:YammerUser = event.data.user as YammerUser;
		 * 		getMessages(user.tabs[0] as YammerTab); // get the first tab of the current user
		 * }
		 * 
		 * // Get a list of messages for the main tab of the current user
		 * private function getMessages(tab:YammerTab):void {
		 * 		service.addEventListener(YammerEvent.MESSAGES_REQUEST_RESULTS, handleMessageList);
		 * 		service.getMessages(tab.url); // the url of the tab
		 * }
		 * 
		 * // Messages are returned in a YammerMessageList object
		 * private function handleMessageList(event:YammerEvent):void {
		 * 		service.removeEventListener(YammerEvent.MESSAGES_REQUEST_RESULTS, handleMessageList);
		 * 		var messageList:YammerMessageList = event.data.messageList as YammerMessageList;
		 * 		var messages:Array = messageList.messages;
		 * }
		 * 
		 * private function requestFailureHandler(event:YammerEvent):void {
		 *     //Handle failure
		 * }
		 * </listing>
		 */ 
		public function Yammer(consumerKey:String = null, consumerSecret:String = null):void
		{
			if (consumerKey && consumerSecret) setConsumerInformation(consumerKey, consumerSecret);
			
			airClient = (Capabilities.playerType.toLowerCase() == "desktop") ? true : false; // are we using an AIR application?
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
			this.oauthToken = oauthToken;
			this.oauthTokenSecret = oauthTokenSecret;
		}
		
		/**
		 * Gets the oauth token.
		 * 
		 * @return oauthToken
		 */
		public function getOuthToken():String
		{
			return this.oauthToken;
		}
		
		/**
		 * Gets the oauth token secret.
		 * 
		 * @return oauthTokenSecret 
		 */
		public function getOuthTokenSecret():String
		{
			return this.oauthTokenSecret;
		}
		
		/**
		 * Request token from the service for your application with your consumer key and secret values. 
		 * The request will return an oauth secret and key.
		 * 
		 * @param consumer_key  The application consumer key
		 * @param consumer_secret The application consumer secret
		 * */
		public function requestToken():void 
		{
			var urlRequest:URLRequest = createRequest(YammerPaths.OAUTH_REQUEST_TOKEN);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onRequestToken);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Save the returned oauth secret and key values.
		 * @private
		 * */
		private function onRequestToken(event:Event):void
		{
			var urlvars:URLVariables = new URLVariables(String(event.target.data));
			
			this.oauthRequestToken = urlvars.oauth_token;
			this.oauthRequestSecret = urlvars.oauth_token_secret;
			
			dispatchEvent(new YammerEvent(YammerEvent.REQUEST_TOKEN, {'oauth_token':oauthRequestToken, 'oauth_token_secret':oauthRequestSecret}));
		}
		
		/**
		 *  Once we have the request tokens, we direct user to the Yammer website for to get the verification pin.
		 *  This will open the users default web browse. 
        * */
        public function sendAuthorizationRequest():void 
        {
			var urlRequest : URLRequest = new URLRequest ();
				urlRequest.url = YammerPaths.OAUTH_AUTHORIZE + "?oauth_token=" + this.oauthRequestToken;
				
			navigateToURL(urlRequest, "_blank");  
		}
		
		/**
		 * If you want to optionally get the path to open your own browser window for getting the verify pin
		 * you can pass in the returned token fro the requestToken method and get the complete path.
		 * 
		 * @return String value for the authorization url to launch in external browser window
		 * */
		public function getAuthorizationRequestPath():String 
		{
			return YammerPaths.OAUTH_AUTHORIZE + "?oauth_token=" + this.oauthRequestToken; 
		}
		
		/**
		 * Getting the Oauth Verify pin is retrieved by sending users to the Yammer web site for authorization. After authorizing 
		 * the appliation, user will need to copy the pin into your application.
		 * 
		 * @param oauth_verify The Oauth verification pin
		 * */
		public function accessToken( oauthVerifier:String ):void 
		{
			this.oauthVerifier = oauthVerifier;
	
			var urlRequest:URLRequest = createRequest(YammerPaths.OAUTH_ACCESS_TOKEN);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, onAccessToken);
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
			
			this.oauthToken = urlvars.oauth_token;
			this.oauthTokenSecret = urlvars.oauth_token_secret;
			
			dispatchEvent(new YammerEvent(YammerEvent.ACCESS_TOKEN, {'oauth_token':oauthToken, 'oauth_token_secret':oauthTokenSecret}));
		}
		
		
		/**
		 * Retrieves a list of all networks and tokens for current user.
		 * The information is needed if you want to offer user option to switch
		 * multiple networks.
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
		 * Retrieves updated network info of all networks for current user.
		 * Information includes permalink, unseen message count, network name, id.
		 * This is useful for knowing the unseen message count for all networks.  
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
		 * <code>Array</code> object and dispatch a <code>YammerEvent.NETWORKS_REQUEST</code> event
		 * with the parsed object.
		 * 
		 * @private
		 * */
		private function onNetworks(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var networks:Array = YammerParser.parseNetworks(obj);
			dispatchEvent(new YammerEvent(YammerEvent.NETWORKS_REQUEST, {"networks":networks}));
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
			var networks:Array = YammerParser.parseCurrentNetworks(obj);
			dispatchEvent(new YammerEvent(YammerEvent.NETWORKS_CURRENT_REQUEST, {"networks":networks}));
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
		 * @param include_group_memberships  Boolean flag to include group memberships in return data
		 */
		public function getCurrentUser(include_followed_users:Boolean = false, include_followed_tags:Boolean = false, include_group_memberships:Boolean = false):void 
		{
			var params:Object = new Object()
				params.include_followed_users = include_followed_users;
				params.include_followed_tags = include_followed_tags;
				params.include_group_memberships = include_group_memberships;
			
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
			try {
				var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
				var user:YammerUser = YammerFactory.user(obj);
				dispatchEvent(new YammerEvent(YammerEvent.CURRENT_USER, {"user":user}));
			} catch (e:Error) { trace(e.message); }
			
		}
		
		/**
		 * Request for user.
		 * @param path The url path for the <code>YammerUser</code> object
		 * */
		public function getUser(path:String):void	
		{			
			path = path + YammerPaths.JSON; // json
			
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
			var user:YammerUser = YammerFactory.user( obj );
			dispatchEvent( new YammerEvent( YammerEvent.USER_REQUEST_RESULTS, {"user":user}) );
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
				//params.no_201=true; // may be needed for web-based application
				
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
				//params.no_201=true; // may be needed for web-based application
			
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
			var path:String = YammerPaths.SUBSCRIPTIONS +  YammerPaths.TO_USER + user_id + ".json";
			var urlRequest : URLRequest = createRequest(path, null, URLRequestMethod.POST);
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
			
			trace("Yammer:: getUserMessages: path: " + path);
			
			//https://www.yammer.com/api/v1/messages/from_user/196383.xml?update_last_seen_message_id=true
			
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
			
			trace("YammerRequest :: postMessage: path: " + path);
			
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
			trace("Yammer:: message list result handler: " + event.target.data);
			try{
				var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
				var messageList:YammerMessageList = YammerParser.parseMessages( obj );
				dispatchEvent( new YammerEvent( YammerEvent.MESSAGES_REQUEST_RESULTS, {"messageList":messageList}) );
			} catch (e:Error){
				trace("JSON error: " + e.message);
			}
		}
		
		
	//------------------------------------------------------------------//
	//------------------------  GROUP METHODS  --------------------------/
	//-----------------------------------------------------------------//
		
		/**
		 * Request for <code>YammerGroup</code>.
		 * @param path The url path for the <code>YammerGroup</code> object
		 * */
		public function getGroup(path:String):void	
		{			
			path = path + YammerPaths.JSON; // json

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
			trace(event.target.data);
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var group:YammerGroup = YammerFactory.group( obj );
			dispatchEvent( new YammerEvent( YammerEvent.GROUP_REQUEST_RESULTS, {"group":group}) );
		}
		
		/**
		 * Join <code>YammerGroup</code>.
		 * @param group_id The id of the <code>YammerGroup</code> to join
		 * */
		public function joinGroup(group_id:String):void
		{
			var path:String = YammerPaths.GROUP_MEMBERSHIPS;
			var params:Object = new Object();
				params.group_id = group_id;
			//params.no_201=true; // may be needed for web-based application
			
			var urlRequest : URLRequest = createRequest(path, params, URLRequestMethod.POST);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); // returns 200 or 201
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Leave <code>YammerGroup</code>.
		 * @param group_id The id of the <code>YammerGroup> to leave
		 * */
		public function leaveGroup(group_id:String):void
		{
			var path:String = YammerPaths.GROUP_MEMBERSHIPS;
			var params:Object = new Object();
			params.group_id = group_id;
			//params.no_201=true; // may be needed for web-based application
			
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
		 * */
		public function getTag(path:String):void	
		{			
			path = path + YammerPaths.JSON; // json
			
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
			dispatchEvent( new YammerEvent( YammerEvent.TAG_REQUEST_RESULTS, {"tag":tag}) );
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
			//params.no_201=true; // may be needed for web-based application because 201 is not handled by Flex
			
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
			//params.no_201=true; // may be needed for web-based application
			
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
		 *
		 * */
		public function isFollowingTag(tag_id:Number):void 
		{
			var path:String = YammerPaths.SUBSCRIPTIONS + "to_tag/" + tag_id + ".json";
			var urlRequest : URLRequest = createRequest(path, null, URLRequestMethod.POST);
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
		 * Request for user.
		 * @param path The url path for the <code>YammerUser</code> object
		 * */
		public function getRSS(path:String):void	
		{			
			path = path + YammerPaths.JSON; // json
			
			var urlRequest : URLRequest = createRequest(path);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleGetRSS);
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}
		
		/**
		 * Result handler rss request.  Converts result object to
		 * <code>YammerUser</code object and dispatch a <code>YammerEvent</code>
		 * with the parsed object.  An RSS (bot) object is essentially identical
		 * to a <code>YammerUser</code> object.
		 * 
		 * @private
		 * */
		private function handleGetRSS(event:Event):void
		{
			var obj:Object = (JSON.decode(String(event.target.data)) as Object);	
			var rss:YammerUser = YammerFactory.user( obj );
			dispatchEvent( new YammerEvent( YammerEvent.RSS_REQUEST_RESULTS, {"rss":rss}) );
		}
		
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
			//params.no_201=true; // may be needed for web-based application
			
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
			//params.no_201=true; // may be needed for web-based application
			
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
			dispatchEvent( new YammerEvent( YammerEvent.RSS_REQUEST_RESULTS, {"suggestions":suggestions}) );
			obj = null;
			suggestions = null;
		}
		
		public function declineSuggestion(id:String):void 
		{
			var path:String = YammerPaths.SUGGESTIONS + id + ".json";
			var params:Object = new Object();
				params.id = id;	   
				
			var urlRequest : URLRequest = createRequest(path, params, "DELETE");
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, handleRequestComplete); 
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPStatus);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				urlLoader.load(urlRequest);
		}       
		
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
			dispatchEvent( new YammerEvent( YammerEvent.RSS_REQUEST_RESULTS, {"requests":requests}) );
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
				
			dispatchEvent( new YammerEvent( YammerEvent.SEARCH_REQUEST_RESULTS, {"search":search}) );

			obj = null;
			search = null;
		}
		
		/**
		 * Auto-complete text search returns tags, users, groups matching search text.
		 * 
		 * @param search_for The text to search for.
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
			
			dispatchEvent( new YammerEvent( YammerEvent.AUTO_COMPLETE_RESULTS, {"matches":matches}) );
			
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
			dispatchEvent(new YammerEvent(YammerEvent.REQUEST_COMPLETE));
		}
		
		/**
		 * Handle security errors.
		 * @private
		 * */
		private function handleSecurityError(event:SecurityErrorEvent):void
		{
			var error:YammerError = new YammerError();
				error.errorMessage = event.text;
				error.errorCode = YammerError.SECURITY_ERROR;
			
			dispatchEvent(new YammerEvent(YammerEvent.SECURITY_ERROR, null, null, error));
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
			
			trace("YammerRequest :: handleIOError: " + String(event.target.data));
			trace("YammerRequest :: handleIOError: " + event.text);
			
			try{
				var obj:Object = JSON.decode(String(event.target.data)) as Object;
				
				if(obj.response) {
					error.errorCode = obj.response.code;
					error.errorMessage = obj.response.message;			
				} else {
					error.errorCode = YammerError.STREAM_ERROR;
					error.errorMessage = obj.error;
				}
			} catch (e:Error) {
				trace("YammerRequest :: handleIOError: " + e.message);
				error.errorCode = YammerError.STREAM_ERROR;
				error.errorMessage = event.text + " You may want to check the http status event.";
			}
			
			dispatchEvent(new YammerEvent(YammerEvent.REQUEST_FAIL, null, null, error));
		}
		
		/**
		 * Handle http status.
		 * @private
		 * */
		private function handleHTTPStatus(event:HTTPStatusEvent):void
		{
			trace("YammerRequest :: handleHTTPStatus: " + event.status);
			
			var error:YammerError = new YammerError();
			if(event.status == 503 || event.status == 0) {
				error.errorCode = YammerError.NO_NETWORK_CONNECTION;
				error.errorMessage = YammerError.getErrorMessage(YammerError.NO_NETWORK_CONNECTION);
				dispatchEvent(new YammerEvent(YammerEvent.REQUEST_FAIL, null, null, error));
			} else if (event.status >= 400) {
				error.errorCode = event.status;
				error.errorMessage = YammerError.getErrorMessage(event.status);
				dispatchEvent(new YammerEvent(YammerEvent.HTTP_STATUS, {"status": event.status}, null, error));
			} else {
				dispatchEvent(new YammerEvent(YammerEvent.HTTP_STATUS, {"status": event.status}));
			}
			
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
		private function createRequest(path:String, params:Object = null, method:String = URLRequestMethod.GET):URLRequest 
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
			
			// set the headers and dump the cookies
			urlRequest.requestHeaders = new Array( new URLRequestHeader("Authorization", createOauthHeader()), new URLRequestHeader("Cookie", "")  );	
			
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
			
			if(this.oauthToken != null) {
				header += "oauth_token=\"";
				header += this.oauthToken;
				header += "\", ";
			}
			
		    header += ("oauth_signature_method=\"");
		    header += ("PLAINTEXT");
		    header += ("\", oauth_signature=\"");
		    header += (this.consumerSecret);
		    header += ("%26");
		    
		    if (this.oauthTokenSecret != null) {
		      	header += (this.oauthTokenSecret);
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
