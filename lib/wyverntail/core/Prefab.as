//
//	Wyvern Tail Project
//  Copyright 2013 Jason Estey
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//

package wyverntail.core 
{
	import flash.utils.Dictionary;

	public class Prefab 
	{
		// the Component classes that will be instanced and attached
		public var components :Vector.<Class>;
		
		// a container of extra parameters for the components
		public var args :Object;
		
		static public var prefabs :Dictionary = new Dictionary();

		// TODO: starting values
		// TODO: can init from XML
		
		public function Prefab() 
		{
			
		}

		static public function define(id :String, components :Vector.<Class>, args :Object) :void
		{
			var prefab :Prefab = new Prefab();
			prefab.components = components;
			prefab.args = args;
			prefabs[id] = prefab;
		}

		static public function spawn(scene :Scene, prefabID :String, spawnArgs :Object = null) :Entity
		{
			var retval :Entity = new Entity(scene);
			scene.add(retval);

			if (spawnArgs == null) { spawnArgs = { }; }

			var prefab :Prefab = prefabs[prefabID] as Prefab;
			if (!prefab) { return retval; }

			var componentInstances :Vector.<Component> = new Vector.<Component>();

			for each (var componentClass :Class in prefab.components)
			{
				componentInstances.push(retval.attachComponent(componentClass));
			}

			// only start the components after they are all attached
			for each (var componentInstance :Component in componentInstances)
			{
				componentInstance.start(prefab.args, spawnArgs);
			}

			return retval;
		}
		
	} // class

} // package
