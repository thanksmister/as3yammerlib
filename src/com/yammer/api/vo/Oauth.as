/**
 * @author Michael Ritchie
 * @email michael.ritchie@gmail.com
 * @twitter thanksmister
 */
package com.yammer.api.vo 
{
	public class Oauth	
	{
		public var oauth_token:String;
		public var oauth_token_secret:String;
	
		public function Oauth(oauth_token:String = null, oauth_secret:String = null)
		{
			this.oauth_token = oauth_token;
			this.oauth_token_secret = oauth_secret
		}
	}
}
