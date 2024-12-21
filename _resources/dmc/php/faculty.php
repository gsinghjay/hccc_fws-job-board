<?php

date_default_timezone_set('America/Los_Angeles');

error_reporting(E_ALL);
ini_set('display_errors', 1);



require_once('_core/class.dmc.php');

$facultyDMC = new FacultyDMC(); // optionally pass an alternate root relative path to data folder. Default is "/_resources/data/".

$email_domain = "hccc.edu";
$email_replacement = "HUDSONCOUNTYCOMMUNITYCOLLEGE";
$mailto_replacement = "SPECIAL_LINK";
$at_replacement = "FREE";

function encode_email($string)
{
	global $email_domain;
	global $email_replacement;
	global $mailto_replacement;
	global $at_replacement;

	$first_one = str_replace('mailto:', $mailto_replacement, $string);
	$second = str_replace($email_domain, $email_replacement, $first_one);
	$final = str_replace('@', $at_replacement, $second);
	return urlencode($final);
}

function create_email_td($faculty)
{
	global $email_domain;
	global $email_replacement;
	global $mailto_replacement;
	global $at_replacement;

	$obfuscated_output = "";
	if (isset($faculty) && $faculty != "") {
		$obfuscated_output .= "<td data-name='email'><a";
		$obfuscated_output .= " data-values-rep-one=\"" . strrev($mailto_replacement) . "\"";
		$obfuscated_output .= " data-values-rep-two=\"" . strrev($at_replacement) . "\"";
		$obfuscated_output .= " data-values-rep-three=\"" . strrev($email_domain) . "\"";
		$obfuscated_output .= " data-values-rep-four=\"" . strrev($email_replacement) . "\"";
		$obfuscated_output .= " data-values-rep-five=\"@\"";
		$obfuscated_output .= " data-values-rep-six=\"" . strrev('mailto:') . "\"";
		$obfuscated_output .= " data-values-do-something=\"true\"";
		$obfuscated_output .= " href=\"" . encode_email('mailto:' . trim($faculty)) . "\">" . encode_email(trim($faculty)) . "</a></td>";
		return $obfuscated_output;
	} else {
		return "";
	}
}

if (str_replace('\\', '/', strtolower(__FILE__)) == str_replace('\\', '/', strtolower($_SERVER['SCRIPT_FILENAME'])) && isset($_GET['datasource']) && $_GET['datasource'] != '') {
	get_faculty_dmc_output(array('endpoint' => true));
}

function get_faculty_dmc_output($options)
{
	global $facultyDMC;
	return $facultyDMC->get_output($options);
}

class FacultyDMC
{

	private $dmc;

	public function __construct($data_folder = null)
	{
		$this->dmc = new DMC($data_folder);
	}

	public function get_output($options)
	{
		$resultSet = $this->dmc->getResultSet($options);
		$templating_function = '';

		switch ($resultSet['meta']['options']['type']) {
			case 'listing':
			$templating_function = 'render_listing';
			break;
		}

		//$resultSet = $this->dmc->xpathFilter($resultSet, "node()[name()='FIRST_NAME' or name()='LAST_NAME'][starts-with(text(), 'P')]");
		$resultSet = $this->dmc->search($resultSet);
		$resultSet = $this->dmc->distinct($resultSet);
		$resultSet = $this->dmc->sort($resultSet);
		$resultSet = $this->dmc->truncate($resultSet);
		$resultSet = $this->dmc->paginate($resultSet);
		$resultSet = $this->dmc->select($resultSet);

		//echo 'Current PHP version: ' . phpversion();
		echo $this->dmc->render($resultSet, array($this, $templating_function));
	}

	public function render_listing($resultSet)
	{

		$output = '
		<div class="faculty faculty--listing">
                  <section class="faculty__list">
				  <table id="facDir" class="display dt-responsive nowrap" width="100%">
                        <thead>
                           <tr>
                              <th>Name / Title</th>
                              <th>Program / Office / School</th>
                              <th>Email</th>
                              <th>Phone</th>
                              <th>Building</th>
                              <th>Office</th>
                           </tr>
                        </thead>

						<tbody>
				  ';

		$items = $resultSet['items'];

		foreach ($items as $i) {

			
			if($i[0]->email !=''){
				$email =  create_email_td($i[0]->email);
			}else{
				$email = '<td data-name="email"></>';
			}
			$first_name = $i->first_name;
			$last_name = $i->last_name;
			$department = $i[0]->department;
			$phone = $i[0]->phone;
			$building = $i[0]->building;
			$room = $i[0]->room_number;
			$role = $i[0]->role;
			$href = $i[0]['href'];


			$link_wrapper_top = '';
			$link_wrapper_bottom = '';
			$role_container = '';

			if ($href != '') {
				$link_wrapper_top = '<a href="' . $href . '">';
				$link_wrapper_bottom = '</a>';
			}
			if ($role != '') {
				$role_container = '
							<br/>
							<span class="type">' . $role . '</span>';
			}
			$output .= '
				<tr>
					<td>
						' . $link_wrapper_top . '
						' . $first_name . ' ' . $last_name . '
						' . $link_wrapper_bottom . '
						' . $role_container . '
					</td>';



			$output .= '
					<td data-name="dep">' . $department . '</td>
					'.$email .'
					<td data-name="phone">' . $phone . '</td>
					<td data-name="building">' . $building . '</td>
					<td data-name="room">' . $room . '</td>
				</tr>';
		}
		$output .= '
				</tbody>
				<tfoot>
                           <tr>
                              <th>Name / Title</th>
                              <th>Program / Office / School</th>
                              <th>Email</th>
                              <th>Phone</th>
                              <th>Building</th>
                              <th>Office</th>
                           </tr>
                        </tfoot>
			</table>
		</section>
	</div>';

		return $output;
	}
}
