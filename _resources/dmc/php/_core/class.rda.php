<?php

	// Real-time Data Aggregation (RDA)

	// error_reporting( E_ALL );
	// ini_set('display_errors', 1);

	class RDA {
		private $session_cookie = '';
		private $log_site = '';
		private $config = array();
		private $raw_payload = '';
		private $payload = array();
		private $publish_path_map = array();
		
		public function __construct($config){
			$this->config = $config;
		}
		
		public function process(){
			$this->raw_payload = file_get_contents('php://input');
			
			if(!$this->is_json($this->raw_payload)){
				echo 'Expected payload was not provided. Script has been aborted.';
				return;
			}
			
			$this->payload = json_decode($this->raw_payload);
			
			if(property_exists($this->payload, 'passed_through_rda') && $this->payload->passed_through_rda == 'true') return; // If this had previously passed through a RDA script so let's abort to prevent recursion.
			
			if($this->is_test_payload()) return; // When the Test button is clicked from account settings simply echo back the payload and abort.
			
			$this->send_next_webhook_request(); // forward payload to another webhook listener.

			if($this->payload->finished != 'true') return; // we only want to react when the event has finished and not when it has been started.
			
			$this->set_publish_path_map(); // sets up an index of publish paths to use as reference to prevent publish recursion.

			foreach($this->config['actions'] as $action){

				if(!$this->payload_contains_trigger_path($action)) continue; // payload does not contain trigger path so end execution.
				
				$this->authenicate();
				$this->publish($action);

			}
			
			$this->log_request();
		}

		private function authenicate(){
			
			if($session_cookie != '') return; // session cookie was already created so exit authenication.
			
			$endpoint = $this->config['ouc_base_url'] . '/authentication/login';

			$config = array(
				'skin' => $this->config['skin'],
				'account' => $this->config['account'],
				'username' => $this->config['username'],
				'password' => $this->config['password']
			);

			$post_fields = http_build_query($config);

			$cURLConnection = curl_init($endpoint);
			curl_setopt($cURLConnection, CURLOPT_POSTFIELDS, $post_fields);
			curl_setopt($cURLConnection, CURLOPT_RETURNTRANSFER, true);
			curl_setopt($cURLConnection, CURLOPT_HEADER, true);

			$api_response = curl_exec($cURLConnection);
			$header  = curl_getinfo( $cURLConnection );
			curl_close($cURLConnection);

			$header_content = substr($api_response, 0, $header['header_size']);

			$pattern = "#Set-Cookie:\\s+(?<cookie>[^=]+=[^;]+)#m"; 
			preg_match_all($pattern, $header_content, $matches); 
			$this->session_cookie = implode("; ", $matches['cookie']);

		}

		private function publish($action){
			$endpoint = '/files/publish';
			
			$config = array(
				'site' => $action['site'],
				'path' => $action['publish_path'],
				'include_scheduled_publish' => 'true',
				'include_checked_out' => 'true'
			);
			

			$this->log_site = $action['site']; // set a site to use to create log files if logging is turned on.

			$this->send($endpoint, $config);
		}
		
		private function set_publish_path_map(){
			
			foreach($this->config['actions'] as $action){
				$this->publish_path_map[$action['site'] . $action['publish_path']] = 1;
			}
			
		}

		private function log_request(){
			if($this->config['log'] != 'true' || $this->log_site == '') return; // don't log when logging turned or if log_site not set
			
			$log_id = uniqid();

			$endpoint = '/files/save';

			$config = array(
				'site' => $this->log_site,
				'path' => $this->config['config_file'], // uses the config PCF to do a "save as" to a log file
				'new_path' => $this->get_root_relative_folderpath() . '_log/' . $log_id . '.txt',
				'text' => $this->raw_payload
			);

			$this->send($endpoint, $config);
		}
		
		private function send_next_webhook_request(){
			$next_webhook_url = trim($this->config['next_webhook_url']);
			
			if($next_webhook_url == '') return; // next_webhook_url not entered so just return.
			
			$this->payload->passed_through_rda = 'true';

			$connection = curl_init($next_webhook_url);
			curl_setopt($connection, CURLOPT_POSTFIELDS, json_encode($this->payload, JSON_UNESCAPED_SLASHES));
			curl_setopt($connection, CURLOPT_RETURNTRANSFER, true);

			$api_response = curl_exec($connection);
			curl_close($connection);

		}

		private function send($endpoint, $config){

			$endpoint = $this->config['ouc_base_url'] . $endpoint;
			$post_fields = http_build_query($config);

			$connection = curl_init($endpoint);
			curl_setopt($connection, CURLOPT_POSTFIELDS, $post_fields);
			curl_setopt($connection, CURLOPT_RETURNTRANSFER, true);

			curl_setopt($connection, CURLOPT_COOKIE, $this->session_cookie);

			$api_response = curl_exec($connection);
			curl_close($connection);
		}
		
		private function payload_contains_trigger_path($action){
			$site = $action['site'];
			
			$success = array(); // the success node in the webhook payload contains files that were published.
			if(!property_exists($this->payload->success, $site)) return false; // no success array so just return false.
			$success =  $this->payload->success->{$site};
			
			$published_paths = array();

			foreach($success as $i){
				if(!array_key_exists($site . $i->path, $this->publish_path_map)) $published_paths[] = $i->path; // only include paths that aren't also publish targets configured in this script to avoid publish recursion.
			}
			
			$trigger_paths = $action['trigger_path'];
			$trigger_paths = explode(',', $trigger_paths);
	
			foreach($trigger_paths as $trigger_path){
				$trigger_path = trim($trigger_path);
				$trigger_path = preg_replace('/(.)[\/]+$/', '$1', $trigger_path); // removes trailing slash unless the value is the string length is 1, for instance: '/'

				if($trigger_path == '') continue;
			
				foreach($published_paths as $path){
					if($this->starts_with($path, $trigger_path)) return true;
				}
			}

			return false;
		}
		
		private function is_test_payload(){
			$account = $this->payload->account;
			
			if($account == '<account name>'){ // This is the account name value used by the test http request.
				echo $this->raw_payload;
				return true;
			}
			
			return false;
		}

		private function is_json($string){
			if(trim($string) == '') return false;
			json_decode($string);
			return (json_last_error() == JSON_ERROR_NONE);
		}

		private function starts_with($string, $startString){
			$len = strlen($startString); 
			return (substr($string, 0, $len) === $startString); 
		}
		
		private function get_root_relative_folderpath(){
			$result = $this->get_root_relative_filepath();
			$result = str_replace('\\', '/', $result);
			$result = preg_replace('/[^\/]+$/', '', $result);
			
			return $result;
		}
		
		private function get_root_relative_filepath(){
			$result = str_replace($_SERVER['DOCUMENT_ROOT'], '', $_SERVER['SCRIPT_FILENAME']);

			return $result;
		}

	}

?>