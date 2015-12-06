//
//	Wyvern Tail Project
//  Copyright 2015 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core
{
	public interface SignalHandler
	{
		function handleSignal(signal :int, sender :Object, args :Object) :Boolean;
	}

} // package
