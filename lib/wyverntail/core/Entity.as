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

	public class Entity
	{
		public var parent :Entity;

		protected var _scene :Scene;
		public function get scene() :Scene { return _scene; }

		protected var _components :Dictionary;

		protected var _prefab :Prefab;
		public function get prefab() :Prefab { return _prefab; }

		protected var _prefabArgs :Object;
		public function get prefabArgs() :Object { return _prefabArgs; }
		protected var _spawnArgs :Object;
		public function get spawnArgs() :Object { return _spawnArgs; }

		public function Entity(scene :Scene, prefab :Prefab, spawnArgs :Object)
		{
			_scene = scene;
			_prefab = prefab;

			_prefabArgs = prefab != null ? prefab.args : null;
			_spawnArgs = spawnArgs;

			_components = new Dictionary();
		}

		public function getProperty(key :String) :Object
		{
			if (_spawnArgs != null && _spawnArgs.hasOwnProperty(key))
			{
				return _spawnArgs[key];
			}

			if (_prefabArgs != null)
			{
				return _prefabArgs[key];
			}

			return null;
		}
		
		public function hasProperty(key :String) :Object
		{
			if (_spawnArgs != null && _spawnArgs.hasOwnProperty(key))
			{
				return true;
			}

			return _prefabArgs.hasOwnProperty(key);
		}

		public function destroy() :void
		{
			for each (var component :Component in _components)
			{
				component.enabled = false;
				component.destroy();
			}
			_components = null;
		}

		public function update(elapsed :Number) :void
		{
			for each (var component :Component in _components)
			{
				component.update(elapsed);
			}
		}

		public function handleSignal(signal :int, sender :Object, args :Object) :Boolean
		{
			var retval :Boolean = false;
			for each (var component :Component in _components)
			{
				if (!component.enabled) { continue; }
				retval = retval || component.handleSignal(signal, sender, args);
			}
			return retval;
		}

		public function attachComponent(componentType :Class) :Component
		{
			if (_components.hasOwnProperty(componentType))
			{
				throw new Error("tried to attach a component when one of the same type was already attached");
			}
			
			_components[componentType] = new componentType();
			var component :Component = _components[componentType] as Component;
			
			if (!component)
			{
				throw new Error("tried to attach a component of type that is not a Component");
			}
			
			component.handleAttach(this);
			return component;
		}

		public function getComponent(componentType :Class) :Component
		{
			return _components[componentType] as Component;
		}

		public function containsComponent(component :Object) :Boolean
		{
			for each (var c :Component in _components)
			{
				if (c == component) { return true; }
			}
			return false;
		}

		public function removeComponent(componentType :Class) :void
		{
			if (!_components.hasOwnProperty(componentType))
			{
				return;
			}
			
			var component :Component = _components[componentType] as Component;
			component.handleRemove();
			
			_components[componentType] = null;
		}

	} // class

} // package

