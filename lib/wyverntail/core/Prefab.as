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
		private var _id :String;
		public function get id() :String { return _id; }

		// the Component classes that will be instanced and attached
		public var components :Vector.<Class>;

		// a container of extra parameters for the components
		public var args :Object;

		static public var prefabs :Dictionary = new Dictionary();

		static public function define(id :String, components :Vector.<Class>, args :Object) :void
		{
			var prefab :Prefab = new Prefab();
			prefab._id = id;
			prefab.components = components;
			prefab.args = args;

			prefabs[id] = prefab;
		}

		static public function spawn(scene :Scene, prefabID :String, spawnArgs :Object = null) :Entity
		{
			if (spawnArgs == null) { spawnArgs = { }; }

			var prefab :Prefab = prefabs[prefabID] as Prefab;
			var retval :Entity = new Entity(scene, prefab, spawnArgs);

			scene.add(retval);
			if (!prefab) { return retval; }

			var componentInstances :Vector.<Component> = new Vector.<Component>();

			for each (var componentClass :Class in prefab.components)
			{
				componentInstances.push(retval.attachComponent(componentClass));
			}

			// only start the components after they are all attached
			for each (var componentInstance :Component in componentInstances)
			{
				componentInstance.start();
			}

			return retval;
		}

		static public function setProperty(prefabID :String, propertyName :String, propertyValue :Object) :void
		{
			var prefab :Prefab = prefabs[prefabID];

			if (prefab == null)
			{
				trace("error: tried to set property on unknown prefab", prefab);
			}

			prefab.args[propertyName] = propertyValue;
		}

	} // class

} // package
