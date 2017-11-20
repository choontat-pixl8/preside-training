/**
 * @singleton true
 * @presideService
 */
component {
	/**
	 * @workflowService.inject WorkflowService
	 * @eventBookingService.inject EventBookingService
	 */
	public any function init( required any workflowService, required any eventBookingService ){
		_setWorkflowService( workflowService );
		_setEventBookingService( eventBookingService );

		return this;
	}

	public array function getSteps(){
		return [ "personalDetail", "sessionDetail", "paymentDetail" ];
	}

	public struct function getStateData(){
		var workflowState = _getState();

		return workflowState.state?:{};
	}

	public string function getCurrentStep(){
		var workflowData = _getState();

		return getNextStep( workflowData.status?:"" );
	}

	public string function getNextStep( required string currentStep ){
		var steps = getSteps();

		return steps[ steps.find( currentStep ) + 1 ]?:"";
	}

	public void function toPreviousStep(){
		var currentStep  = getCurrentStep();
		var savedStep    = getPreviousStep( currentStep );
		var previousStep = getPreviousStep( savedStep   );

		saveStep( step=previousStep, data={} );
	}

	public string function getPreviousStep( required string currentStep ){
		var steps = getSteps();

		return steps[ steps.find( currentStep ) - 1 ] ?: "-";
	}

	public void function saveStep( required string step, struct data={} ){
		var workflowArgs = _getBasicWorkflowArgs();

		workflowArgs.state  = data;
		workflowArgs.status = step;

		_getWorkflowService().appendToState( argumentCollection=workflowArgs );
	}

	private struct function _getState(){
		var workflowArgs = _getBasicWorkflowArgs();

		return _getWorkflowService().getState( argumentCollection=workflowArgs );
	}

	public boolean function complete(){
		return _getWorkflowService().complete( argumentCollection=_getBasicWorkflowArgs() );
	}

	private struct function _getBasicWorkflowArgs(){
		return {
			  workflow  = "eventBooking"
			, reference = "eventBooking"
			, expires   = dateAdd( "n", 30, now() ) // Expires in 30 minutes
		};
	}

	private any function _getWorkflowService(){
		return variables._workflowService;
	}

	private void function _setWorkflowService( required any workflowService ){
		variables._workflowService = arguments.workflowService;
	}

	private any function _getEventBookingService(){
		return variables._eventBookingService();
	}

	private void function _setEventBookingService( required any eventBookingService ){
		variables._eventBookingService = arguments.eventBookingService;
	}
}