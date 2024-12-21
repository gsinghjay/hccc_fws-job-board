<?php

date_default_timezone_set('America/Los_Angeles');
setlocale(LC_MONETARY, "en_US");

error_reporting( E_ALL );
ini_set('display_errors', 1);

require_once('_core/class.dmc.php');

$coursesDMC = new CoursesDMC(); // optionally pass an alternate root relative path to data folder. Default is "/_resources/data/".

if(str_replace('\\', '/', strtolower(__FILE__)) == str_replace('\\', '/', strtolower($_SERVER['SCRIPT_FILENAME'])) && isset($_GET['datasource']) && $_GET['datasource'] != ''){
	get_courses_dmc_output(array('endpoint' => true));
}

function get_courses_dmc_output($options){
	global $coursesDMC;
	return $coursesDMC->get_output($options);
}

class CoursesDMC {

	private $dmc;

	public function __construct($data_folder = null){
		$this->dmc = new DMC($data_folder);
	}

	public function get_output($options){
		$resultSet = $this->dmc->getResultSet($options);
		$templating_function = '';

		switch($resultSet['meta']['options']['type']){
			case 'summary':
			$templating_function = 'render_summary';
			break;
			case 'offerings':
			$templating_function = 'render_offerings';
			break;
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

	public function render_listing($resultSet){
		$output = "";
		$items = $resultSet['items'];
		$pageTitle = $resultSet['meta']['options']['page-title'];
			

		$output .= '<article>';
// 		$output .= '	<div class="add-to-cart-button" style="float:right;">';
// 		$output .= '		<button>';
// 		$output .= '			<i class="fa fa-shopping-cart">';
// 		$output .= '			</i>';
// 		$output .= '			Your Cart (0)';
// 		$output .= '		</button>';
// 		$output .= '	</div>';
		$output .= '	<div class="mc-section__header">';
		$output .= '		<h2>'.$pageTitle.'</h2>';
		$output .= '	</div>';
		$output .= '	<div class="entry-content">';
		$output .= '		<div class="courses-div">';

		if(count($items) > 0) {
			foreach($items as $i){
				$prog = $i;
				$href = $i->attributes()->href;				
				$title = $prog->title;
				$code = $prog->code;
				$summary= $prog->{'program-summary-brief'};
				$output .= '<div class="listing-item">';
				$output .= '	<a class="title" href="'. $href .'">' . $code .' | '. $title .'</a>';
				$output .= '	<div class="mc-content">';
				$output .= '		<p>'. $summary .'</p>';
				$output .= '	</div>';
				$output .= '	<section class="elevate-catalog elevate-catalog-program">';
				$output .= '		<div class="elevate-catalog-clearfix">';
				$output .= '			<div class="elevate-cart" style="float:right;">';
				$output .= '			</div>';
				$output .= '		</div>';

				$instances = $prog->{'program-instances'}->{'program-instance'};
				
				if(count($instances) > 0){
					$output .= '<section class="elevate-catalog elevate-catalog-program">';
					$output .= '	<div class="elevate-catalog-clearfix">';
// 					$output .= '		<div id="elevate-cart" style="float:right;">';
// 					$output .= '			<div class="add-to-cart-button">';
// 					$output .= '				<button>';
// 					$output .= '					<i class="fa fa-shopping-cart">';
// 					$output .= '					</i>';
// 					$output .= '					Your Cart (0)';
// 					$output .= '				</button>';
// 					$output .= '			</div>';
// 					$output .= '		</div>';
					$output .= '	</div>';
					$output .= '	<article class="single-program">';
					$output .= '		<div class="entry-header">';
					$output .= '			<h3 class="entry-title">'.$title.'</h3>';
					$output .= '		</div>';
					$output .= '		<hr/>';

					foreach($instances as $prog){
						$output .= '		<div class="sub-entry-content">';
						$output .= '			<div class="program-title">';
						$output .= '				<h3>'.$prog->{'program-instance-title'}.'</h3>';
						$output .= '			</div>';
						$output .= '			<table>';
						$output .= '				<thead>';
						$output .= '					<tr>';
						$output .= '						<th scope="col">Start Date</th>';
						$output .= '						<th scope="col">End Date</th>';
						$output .= '						<th scope="col">Fee</th>';
						$output .= '						<th scope="col"></th>';
						$output .= '					</tr>';
						$output .= '				</thead>';
						$output .= '				<tr>';
						$output .= '					<td>'.$this->format_date($prog->{'start-date'}).'</td>';
						$output .= '					<td>'.$this->format_date($prog->{'end-date'}).'</td>';
						$output .= '					<td>'.$this->format_money($prog->fee).'</td>';
						$output .= '					<td class="add-to-cart" style="text-align:right;"></td>';
						$output .= '				</tr>';
						$output .= '			</table>';
						$output .= '			<table>';
						$output .= '				<thead>';
						$output .= '					<tr>';
						$output .= '						<th scope="col">Course Content</th>';
						$output .= '					</tr>';
						$output .= '				</thead>';
						$output .= '				<tr>';
						$output .= '					<td>';
						$output .= '						<strong>'.$prog->{'program-instance-title'}.' - '.$prog->code.'</strong>';
						$output .= '					</td>';
						$output .= '				</tr>';
						$output .= '			</table>';
						$output .= '			<table>';
						$output .= '				<thead>';
						$output .= '					<tr>';
						$output .= '						<th scope="col">Start Date</th>';
						$output .= '						<th scope="col">End Date</th>';
						// 				$output .= '						<th scope="col">Class Schedule</th>';
						// 				$output .= '						<th scope="col">Time</th>';
						// 				$output .= '						<th scope="col">Instructor</th>';
						$output .= '						<th scope="col">Location</th>';
						$output .= '						<th scope="col">Credits/CEU\'s</th>';
						$output .= '					</tr>';
						$output .= '				</thead>';
						$output .= '				<tr>';
						$output .= '					<td>'.$this->format_date($prog->{'start-date'}).'</td>';
						$output .= '					<td>'.$this->format_date($prog->{'end-date'}).'</td>';
						// 				$output .= '					<td>Day</td>';
						// 				$output .= '					<td>Time</td>';
						// 				$output .= '					<td>N/A</td>';
						$output .= '					<td>'.$prog->location->title.'</td>';
						$output .= '					<td>'.$prog->credits.'</td>';
						$output .= '				</tr>';
						$output .= '			</table>';
						$output .= '			<div class="add-to-cart-button">';
						$output .= '					<button onclick="window.open(\''.$prog->services->service[0]->url.'\',\'_blank\')" type="button">';
						$output .= '						<i class="fa fa-shopping-cart">';
						$output .= '						</i>';
						$output .= '						Add To Cart';
						$output .= '					</button>';
						$output .= '			</div>';
						$output .= '			<hr/>';
						$output .= '		</div>';
					}
					$output .= '	</article>';
					$output	.= '</section>';
				} else {
					$output .= '		<article class="single-program" id="post-">';
					$output .= '			<h3 class="entry-title">No Course Available</h3>';
					$output .= '			<hr/>';
					$output .= '			<div class="sub-entry-content">';
					$output .= '				<span class="nocourseslist">';
					$output .= 'No available sections found.';
					$output .= '					<br/>';
					$output .= '					<a href="https://ce.bergen.edu/business-and-technology-courses/bi-345/" title="BI-345 | Agile Project Management">Click here to request one.</a>';
					$output .= '					<br />';
					$output .= '				</span>';
					$output .= '			</div>';
					$output .= '			<hr />';
					$output .= '		</article>';
				}
				$output .= '	</section>';
				$output .= '</div>';
			}
		}
		else {
			$output .= '<p class="no-results">No course found with the specified course id.';
		}

		$output .= '		</div>';
		$output .= '	</div>';
		$output .= '</article>';

		return $output;
	}

	public function render_summary($resultSet){
		$output = "";
		$items = $resultSet['items'];

		foreach($items as $i){
			$title = $i->title;
			$code = $i->code;
			$summary= $i->{'program-summary-brief'};
			$output .= '<div class="container">';
			$output .= '<article class="">';
			$output .= '<div class="">';
			$output .= '<h2>'.$title.' - '.$code.'</h2>';
			$output .= '</div>';
			$output .= '<div>';
			$output .= $summary;
			$output .= '</div>';
			$output .= '</article>';
		}

		if(count($items) == 0) $output .= '<p class="no-results">No course found with the specified course id.';

		return $output;
	}

	public function render_offerings($resultSet){
		$output = "";

		$items = $resultSet['items'];

		foreach($items as $i){
			$title = $i->title;
			$instances = $i->{'program-instances'}->{'program-instance'};

			if(count($instances) > 0){
				$output .= '<section class="elevate-catalog elevate-catalog-program">';
// 				$output .= '	<div class="elevate-catalog-clearfix">';
// 				$output .= '		<div id="elevate-cart" style="float:right;">';
// 				$output .= '			<div class="add-to-cart-button">';
// 				$output .= '				<button>';
// 				$output .= '					<i class="fa fa-shopping-cart">';
// 				$output .= '					</i>';
// 				$output .= '					Your Cart (0)';
// 				$output .= '				</button>';
// 				$output .= '			</div>';
// 				$output .= '		</div>';
// 				$output .= '	</div>';
				$output .= '	<article class="single-program">';
				$output .= '		<div class="entry-header">';
				$output .= '			<h3 class="entry-title">'.$title.'</h3>';
				$output .= '		</div>';
				$output .= '		<hr/>';

				foreach($instances as $prog){
					$output .= '		<div class="sub-entry-content">';
					$output .= '			<div class="program-title">';
					$output .= '				<h3>'.$prog->{'program-instance-title'}.'</h3>';
					$output .= '			</div>';
					$output .= '			<table>';
					$output .= '				<thead>';
					$output .= '					<tr>';
					$output .= '						<th scope="col">Start Date</th>';
					$output .= '						<th scope="col">End Date</th>';
					$output .= '						<th scope="col">Fee</th>';
					$output .= '						<th scope="col"></th>';
					$output .= '					</tr>';
					$output .= '				</thead>';
					$output .= '				<tr>';
					$output .= '					<td>'.$this->format_date($prog->{'start-date'}).'</td>';
					$output .= '					<td>'.$this->format_date($prog->{'end-date'}).'</td>';
					$output .= '					<td>'.$this->format_money($prog->fee).'</td>';
					$output .= '					<td class="add-to-cart" style="text-align:right;"></td>';
					$output .= '				</tr>';
					$output .= '			</table>';
					$output .= '			<table>';
					$output .= '				<thead>';
					$output .= '					<tr>';
					$output .= '						<th scope="col">Course Content</th>';
					$output .= '					</tr>';
					$output .= '				</thead>';
					$output .= '				<tr>';
					$output .= '					<td>';
					$output .= '						<strong>'.$prog->{'program-instance-title'}.' - '.$prog->code.'</strong>';
					$output .= '					</td>';
					$output .= '				</tr>';
					$output .= '			</table>';
					$output .= '			<table>';
					$output .= '				<thead>';
					$output .= '					<tr>';
					$output .= '						<th scope="col">Start Date</th>';
					$output .= '						<th scope="col">End Date</th>';
					// 				$output .= '						<th scope="col">Class Schedule</th>';
					// 				$output .= '						<th scope="col">Time</th>';
					// 				$output .= '						<th scope="col">Instructor</th>';
					$output .= '						<th scope="col">Location</th>';
					$output .= '						<th scope="col">Credits/CEU\'s</th>';
					$output .= '					</tr>';
					$output .= '				</thead>';
					$output .= '				<tr>';
					$output .= '					<td>'.$this->format_date($prog->{'start-date'}).'</td>';
					$output .= '					<td>'.$this->format_date($prog->{'end-date'}).'</td>';
					// 				$output .= '					<td>Day</td>';
					// 				$output .= '					<td>Time</td>';
					// 				$output .= '					<td>N/A</td>';
					$output .= '					<td>'.$prog->location->title.'</td>';
					$output .= '					<td>'.$prog->credits.'</td>';
					$output .= '				</tr>';
					$output .= '			</table>';
					$output .= '			<div class="add-to-cart-button">';	
					$output .= '					<button onclick="window.open(\''.$prog->services->service[0]->url.'\',\'_blank\')" type="button">';
					$output .= '						<i class="fa fa-shopping-cart">';
					$output .= '						</i>';
					$output .= '						Add To Cart';
					$output .= '					</button>';
					$output .= '			</div>';
					$output .= '			<hr/>';
					$output .= '		</div>';
				}
				$output .= '	</article>';
				$output	.= '</section>';
			} else {
				$output .= '<p class="no-results">No available courses.';
			}
		}

		return $output;
	}

	public function format_money($value) {
		if ($value<0) return "-".format_money(-$value);
		return '$' . number_format(floatval($value), 2);
	}

	public function format_date($date){
		return date_format(new DateTime($date),"M jS, Y");
	}
}
?>