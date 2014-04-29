/*
	Author:  Abdul Qabiz (abdulqabiz3@yahoo.com) 
	Copyright (c) 2007 Abdul Qabiz (http://www.abdulqabiz.com)
	All rights reserved.

	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

	* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
	in the documentation and/or other materials provided with the distribution.
	* Neither the name of the <ORGANIZATION> nor the names of its contributors may be used to endorse
	or promote products derived from this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
	A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
	CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
	EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
	PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
	LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
	NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


/**
	_________________________________________________________________________________________________________________

	HTTPURLLoader is small http client for GET requests and header manipulation.	
	@class HTTPURLLoader (public)
	@author Abdul Qabiz (mail at abdulqabiz dot com) 
	@version 1.01 (3/5/2007)
	@availability 9.0+
	@usage<code>new HTTPURLLoader ();</code>
	@example
		<code>
			httpURLLoader = new HTTPURLLoader ();
		</code>
	__________________________________________________________________________________________________________________

	*/

package com.kiwind.utils
{

	import flash.net.*;
	import flash.events.*;
	import flash.system.Security;
	import flash.errors.EOFError;
	import flash.utils.*;
	//import mx.utils.StringUtil;


	dynamic public class HTTPURLLoader extends EventDispatcher
	{
		
		//Events
		[Event(name="close", type="flash.events.Event.CLOSE")]
		[Event(name="complete", type="flash.events.Event.COMPLETE")]
		[Event(name="open", type="flash.events.Event.CONNECT")]
		[Event(name="ioError", type="flash.events.IOErrorEvent.IO_ERROR")]
		[Event(name="securityError", type="flash.events.SecurityErrorEvent.SECURITY_ERROR")]
		[Event(name="progress", type="flash.events.ProgressEvent.PROGRESS")]
		[Event(name="httpStatus", type="flash.events.HTTPStatusEvent.HTTP_STATUS")]
		
				
		//class attributes
		private var _httpPort:uint = 80;
		private var socket:Socket;
		private var _request:URLRequest;
		public  var _httpRequest:String;
		public  var _httpServer:String;
		private var headerComplete:Boolean = false;
		private var _header:Object;
		private var _data:String = "";
		private var _bytesLoaded:int = 0;
		private var _bytesTotal:int = 0;
		private var headerTmp:String = "";
		private var _httpVersion:Number;
		private var _httpStatusCode:int;
		private var _httpStatusText:String; 

		
		public function HTTPURLLoader(request:URLRequest = null)
		{
			
			//doesn't really need it here, as load(..) requires request
			_request = request;	
					
			// create http-socket
			socket = new Socket();

			//subscribe to events
			socket.addEventListener( "connect" , onConnectEvent , false , 0 );				
			socket.addEventListener( "close" , onCloseEvent , false, 0 );
			socket.addEventListener( "ioError" , onIOErrorEvent , false, 0 );
			socket.addEventListener( "securityError" , onSecurityErrorEvent , false, 0 );
			socket.addEventListener( "socketData" , onSocketDataEvent , false , 0 );
		}
	/*__________________________________________________________________________________________________________________

		Public Methods
		__________________________________________________________________________________________________________________
	*/
	
		public function load(request:URLRequest):void
		{
			_request = request;
			if(parseURL())
			{
				try
				{
					socket.connect(_httpServer, _httpPort);
				}
				catch (e:Error)
				{
					
				}
				
			}
			else
			{
				throw new Error("Invalid URL");
			}								
				
		}
		
		public function close():void
		{
			if(socket.connected)
			{
				socket.close();
				dispatchEvent(new Event(Event.CLOSE));
			}
		}

	/*__________________________________________________________________________________________________________________

		Public Properties
		__________________________________________________________________________________________________________________
	*/

		public function get data():String
		{
			return _data;
		}

		public function get header():Object
		{
			return _header;
		}		
		
		public function get bytesLoaded():int
		{
			return _bytesLoaded;
		}
	
		public function get bytesTotal ():int
		{
			return _bytesTotal;
		}
		
	/*__________________________________________________________________________________________________________________

		Private Methods
		__________________________________________________________________________________________________________________
	*/
		private function onConnectEvent(event:Event):void
		{	
		
			sendHeaders();
			dispatchEvent(new Event(Event.CONNECT));
				
		}
			
		private function onCloseEvent(event:Event):void
		{
			dispatchEvent(new Event(flash.events.Event.COMPLETE));

		}
			
		private function onIOErrorEvent(event:IOErrorEvent):void
		{ 

			dispatchEvent(event);
		}
		
		private function onSecurityErrorEvent(event:SecurityErrorEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		private function onSocketDataEvent(event:ProgressEvent):void 
		{
			_bytesLoaded += socket.bytesAvailable;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, _bytesLoaded, _bytesTotal))
			var str:String = "";
			try 
			{
				str = socket.readUTFBytes(socket.bytesAvailable);
			}
			 catch(e:Error) 
			{
			}
			if(!headerComplete) 
			{
				var httpStatus:String;
				var headerEndIndex:int = str.indexOf("\r\n\r\n");
				if(headerEndIndex != -1) 
				{
					headerTmp += str.substring(0, headerEndIndex);
					headerComplete = true;
					_data += str.substring(headerEndIndex + 4);
					var headerArr:Array = headerTmp.split("\r\n");
					var headerLine:String;
					var headerParts:Array;
					for each(headerLine in headerArr) 
					{
						if(headerLine.indexOf("HTTP/1.") != -1) 
						{
							headerParts = headerLine.split(" ");
							if(headerParts.length > 0) 
							{
								_httpVersion = parseFloat(StringUtil.trim(headerParts.shift().split("/")[1]));
							}
							if(headerParts.length > 0) 
							{
								_httpStatusCode = parseInt(StringUtil.trim(headerParts.shift()));
							}
							if(headerParts.length > 0) 
							{
								_httpStatusText = StringUtil.trim(headerParts.join(" "));
							}
							dispatchEvent(new HTTPStatusEvent(HTTPStatusEvent.HTTP_STATUS, false, false, _httpStatusCode));
						} 
						else 
						{
							var colonIndex:int = headerLine.indexOf(":");
							if(colonIndex != -1) {
								var key:String = StringUtil.trim(headerLine.substring(0, colonIndex));
								var value:String = StringUtil.trim(headerLine.substring(colonIndex + 1));
								if (!_header)
								{
									_header = new Object ();
								}
								
								_header[key] = value;
							}
						}
					}
					if(_header["Content-Length"]) 
					{
						// total bytes = content-length + header size (number of characters in header)
						// not working, need to work on right logic..
						_bytesTotal = int(_header["Content-Length"]) + headerTmp.length;
					}
				} 
				else 
				{
					headerTmp += str;
				}
			} 
			else 
			{
				_data += str;
			}
		}
	
		
		private function sendHeaders():void
		{
			var requestHeaders:Array = _request.requestHeaders;

			var h:String = "";
	
			_header = null;
			_bytesLoaded = 0;
			_bytesTotal = 0;
			_data = "";
			headerComplete = false;
			headerTmp = "";


							
			//create an HTTP 1.0 Header Request
			h+= "GET " + _httpRequest + " HTTP/1.0\r\n";
			h+= "Host:" + _httpServer + "\r\n";

			if(requestHeaders.length > 0)
			{
				for each(var rh:URLRequestHeader in requestHeaders)
				{
					h+= rh.name + ":" + rh.value + "\r\n";
	
				}
			}
			

			//set HTTP headers to socket buffer
			socket.writeUTFBytes(h + "\r\n\r\n")

			//push the data to server
			socket.flush()			
		}

		private function parseURL():Boolean
		{
				
			//parse URL into sockServer and sockRequest
			
			var d:Array = _request.url.split('http://')[1].split('/');
			if(d.length > 0)
			{
				_httpServer = d.shift();

				//load crossdomain, if its on server.
				Security.loadPolicyFile("http://"+_httpServer+"/crossdomain.xml");
				_httpRequest = '/' + d.join('/');
				return true;
			}
			return false;

		}

		
	}
	
}
