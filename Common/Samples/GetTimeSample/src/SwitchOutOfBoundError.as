package
{
	public class SwitchOutOfBoundError
	{
		// members
		private var _value:*;
		
		// properties
		public function get Value():*
		{
			return _value;
		}
		
		// class
		public function SwitchOutOfBoundError(value:*)
		{
			_value = value;
		}
	}
}