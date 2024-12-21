<?php

date_default_timezone_set('America/New_York');

// 	error_reporting( E_ALL );
// 	ini_set('display_errors', 1);

require_once('_core/class.dmc.php');

$eventsDMC = new EventsDMC(); // optionally pass an alternate root relative path to data folder. Default is "/_resources/data/".

if(str_replace('\\', '/', strtolower(__FILE__)) == str_replace('\\', '/', strtolower($_SERVER['SCRIPT_FILENAME'])) && isset($_GET['datasource']) && $_GET['datasource'] != ''){
	get_events_dmc_output(array('endpoint' => true));
}

function get_events_dmc_output($options){
	global $eventsDMC;
	return $eventsDMC->get_output($options);
}

class EventsDMC {

	private $dmc;

	public function __construct($data_folder = null){
		$this->dmc = new DMC($data_folder);
	}

	public function get_output($options){
		$resultSet = $this->dmc->getResultSet($options);
		$templating_function = '';

		switch($resultSet['meta']['options']['type']){
			case 'details':
			$templating_function = 'render_details';
			break;
			case 'listing':
			$templating_function = 'render_listing';
			break;
			case 'event_items':
			$templating_function = 'render_event_items';
			break;
			case 'homepage_events_list':
			$templating_function = 'render_homepage_events_list';
			$resultSet = $this->remove_past_dates($resultSet);
			break;
			case 'generic_events_list':
			$templating_function = 'render_generic_events_list';
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

	public function render_generic_events_list($resultSet){
		$output = "";		
		$items = $resultSet['items'];		

		$output .= '<div class="column column--three">';

		foreach ($items as $i) {
			$cDate = strtotime($i->pubDate);
			$output .= '
				<div class="column__col events3up__item">
					<div class="events3up__date">
						<div class="events3up__month">
							'.strtoupper(date("M", $cDate)).'
						</div>
						<div class="events3up__day">
							'.date("d", $cDate).'
						</div>
						<div class="events3up__year">
							'.date("Y", $cDate).'
						</div>
					</div>
					<div class="events3up__right">
						<h3>
							<a href="'.$i->link.'">'.$i->title.'</a>
						</h3>
						<div class="events3up__data">
							<div class="events3up__time">';

			if($i->tbd == 0){
				$output .= 	$i->startTime.' - '.$i->endTime;
			}elseif ($i->tbd == 1){
				$output .= "All Day";
			}else{
				$output .= "TBD";
			}

			$output .= '									
							</div>
							<div class="events3up__location">
								'.$i->locationName.'
							</div>
						</div>
					</div>
				</div>
			';
		}

		$output .= '</div>';

		return $output;
	}

	public function render_homepage_events_list($resultSet){
		$output = "";		
		$items = $resultSet['items'];

		echo $items[0];

		$output .= '<div class="column column--three">';

		if (count($items) >= 1) {
			foreach ($items as $i) {
				$cDate = strtotime($i->pubDate);
				$cDate = preg_replace('/\s*-\d{4}\s*/', '', $cDate);

				$output .= '
				<div class="column__col events3up__item">
					<div class="events3up__date">
						<div class="events3up__month">
							'.strtoupper(date("M",$cDate)).'
						</div>
						<div class="events3up__day">
							'.date("d",$cDate).'
						</div>
						<div class="events3up__year">
							'.date("Y",$cDate).'
						</div>
					</div>
					<div class="events3up__right">
						<h3>
							<a href="'.$i->link.'">'.$i->title.'</a>
						</h3>
						<div class="events3up__data">
							<div class="events3up__time">';

				if($i->tbd == 0){
					$output .= 	$i->startTime.' - '.$i->endTime;
				}elseif ($i->tbd == 1){
					$output .= "All Day";
				}else{
					$output .= "TBD";
				}

				$output .= '
							</div>
							<div class="events3up__location">
								'.$i->locationName.'
							</div>
						</div>
					</div>
				</div>
			';
			}
		}
		else {
			//$cDate = strtotime($items[0]->pubDate);

			$output .= '
				<div class="column__col events3up__item">
					<div class="events3up__date">
						<div class="events3up__month">
							'.strtoupper(date("M")).'
						</div>
						<div class="events3up__day">
							'.date("d").'
						</div>
						<div class="events3up__year">
							'.date("Y").'
						</div>
					</div>
					<div class="events3up__right">
						<h3>
							<a href="'.$items[0]->link.'">'.$items[0]->title.'</a>
						</h3>
						<div class="events3up__data">
							<div class="events3up__time">';

			if($items[0]->tbd == 0){
				$output .= 	$i->startTime.' - '.$items[0]->endTime;
			}elseif ($items[0]->tbd == 1){
				$output .= "All Day";
			}else{
				$output .= "TBD";
			}

			$output .= '
							</div>
							<div class="events3up__location">
								'.$items[0]->locationName.'
							</div>
						</div>
					</div>
				</div>
			';
		}

		$output .= '</div>';
		return $output;
	}


	public function render_event_items($resultSet){
		$output = "";
		$items = $resultSet['items'];
		$title = $resultSet['meta']['options']['title'];
		$output .=  '	<div class="container">';
		$output .= '  <p style="font-size:28px;">'. $title . '</p>';
		$output .=  '	<div class="row">';

		foreach ($items as $i) {
			$output .=  '	<div class="col-sm-4">';
			$output .=  '	<div class="card" style="width: 18rem;">';
			$output .=  '		<div class="card-body">';
			$output .=  '		<p style="font-size:20px;" class="card-title">'. $i->title .'</p>';
			$output .=  '		<p class="card-text">'. $i->description .'</p>';
			$output .=  '	<a href="'. $i->link .'" class="btn btn-primary">Check Event</a>';
			$output .=  '  </div>';
			$output .=  '</div>';
			$output .=  '</div>';
		}
		$output .=  '</div>';
		$output .=  '</div>';

		return $output;
	}




	public function render_details($resultSet){
		$output = "";
		$items = $resultSet['items'];

		foreach($items as $i){
			$office = "{$i->building} {$i->room_number}";
			$phone = $this->format_phone($i->phone);
			$output .= "<h2>{$i->first_name} {$i->LAST_NAME}</h2>";
			if($i->title != '' || $i->department != ''){
				$output .= '<p>';
				$output .= '	<strong>';

				if($i->title != '') $output .= $i->title;
				if($i->title != '' && $i->department != '') $output .= ', ';
				if($i->department != '') $output .= $i->department;

				$output .= '	</strong>';
				$output .= '</p>';
			}

			if($office != '') $output .= "<p>Office: {$office}</p>";
			if($phone != '') $output .= "<p>Phone: {$phone}</p>";
			if($i->email != '') $output .= "<p>E-mail: {$i->email}</p>";
		}

		return $output;
	}


	//CARD VERSION 1

	public function render_listing($resultSet){
		$output = "";
		$filterForm = $this->render_filter_form($resultSet);
		$pagination = $this->render_pagination($resultSet);

		$items = $resultSet['items'];
		foreach($items as $i){
			$office = $i->building . ' ' . $i->room_number;
			$phone = $this->format_phone($i->phone);
			$href = $i->attributes()->href;
			$output .= "<div class='card'>";
			$output .= "<div class='row'>";
			$output .= "<div class='col-md-3'>";
			if ($i->image->img->attributes()->src !='') {
				$output .= "<img src='{$i->image->img->attributes()->src}' class='card-img' alt=''>";
			} else {
				$output .= "<img src='https://bpt.oudemo.com/_resources/images/profile-image.png' class='card-img' alt='placeholder'>";
			}
			$output .= "</div>";
			$output .= "<div class='col-md-9'><div class='card-body'>";
			$output .= "<h4 class='card-title'><a href=\"{$href}\">{$i->last_name}, {$i->first_name}</a></h4>";
			if($i->title != '' || $i->department != ''){
				$output .= '<p>';
				if($i->abbreviated_title != '') $output .= $i->abbreviated_title;
				if($i->abbreviated_title != '' && $i->department != '') $output .= ', ';
				if($i->department != '') $output .= $i->department;
				$output .= '</p>';
			}
			if($office != '') $output .= "<p>{$i->office_hours}<br/>{$office}";
			if($i->phone != '') $output .= "<br/>Phone: {$i->phone}";
			if($i->email != '') $output .= "<br/>E-mail: {$i->email}</p>";
			$output .= "</div></div></div></div>";
		}

		return $filterForm . $output . $pagination;
	}





	private function render_filter_form($resultSet){
		$items_per_page_options = array(
			"5"=>"5",
			"10"=>"10",
			"20"=>"20",
			"30"=>"30",
			"40"=>"40",
			"50"=>"50",
			"100"=>"100",
			"200"=>"200",
			""=>"All"
		);


		$result = '';
		$result .= '<form>';
		$result .= '<div class="large-12 columns">';
		$result .= '	<div class="row collapse">';
		$result .= '		<div class="small-4 columns">';
		$result .= '			<label>Items per Page';
		$result .= '				<select name="items_per_page">';
		foreach ($items_per_page_options as $key => $val){ 
			$result .= '<option value="'.$key.'"';
			if($key == $resultSet['meta']['options']['items_per_page']) $result .= ' selected';
			$result .= '>'.$val.'</option>';

		}
		$result .= '				</select>';
		$result .= '			</label>';
		$result .= '		</div>';
		$result .= '		<div class="small-6 columns">';
		$result .= '			<label>Search Phrase';
		$result .= '				<input type="text" name="search_phrase" value="'.$resultSet['meta']['options']['search_phrase'].'">';
		$result .= '			</label>';
		$result .= '		</div>';
		$result .= '		<div class="small-2 columns">';
		$result .= '			<label>&nbsp;';
		$result .= '				<input type="submit" class="button postfix" value="search" />';
		$result .= '			</label>';
		$result .= '		</div>';
		$result .= '	</div>';
		$result .= '</div>';
		$result .= $this->build_hidden_inputs($resultSet);
		$result .= '</form>';
		return $result . '<br style="clear:right;" />';

	}

	private function build_hidden_inputs($resultSet){
		$result = '';

		$result .= '<input type="hidden" name="sort" value="'.$resultSet['meta']['options']['sort'].'" />';
		$result .= '<input type="hidden" name="page" value="1" />';

		return $result;
	}

	private function render_pagination($resultSet){
		$result = '';

		if(!isset($resultSet['meta']['pagination'])) return $result;

		$totalPages = $resultSet['meta']['pagination']['page_count'];
		$page = $resultSet['meta']['pagination']['current_page'];
		if($totalPages < 2) return ''; // only return the pagination if there are more than 1 page.
		$previousPage = $page - 1;
		$nextPage = $page + 1;

		$query_string = $_SERVER['QUERY_STRING'];
		$result .= '<nav aria-label="Page navigation"><ul class="pagination pull-right">';
		if($previousPage > 0){
			$result .= '    <li class="page-item"><a class="page-link" href="?' . $this->dmc->updateQuerystringParameter($query_string, 'page', $previousPage) . '">« <span class="sr-only">Previous</span></a></li>';
		}
		for ($i = 1; $i <= $totalPages; $i++) {
			if($i == $page){
				$result .= '    <li class="page-item active"><a class="page-link" href="?' . $this->dmc->updateQuerystringParameter($query_string, 'page', $i) . '">' . $i . '</a></li>';
			}else{
				$result .= '    <li class="page-item"><a class="page-link" href="?' . $this->dmc->updateQuerystringParameter($query_string, 'page', $i) . '">' . $i . '</a></li>';
			}
		}
		if($nextPage <= $totalPages){
			$result .= '    <li class="page-item"><a class="page-link" href="?' . $this->dmc->updateQuerystringParameter($query_string, 'page', $nextPage) . '"><span class="sr-only">Next</span> »</a></li>';    
		}
		$result .= '</ul></nav>';
		return $result . '<br style="clear:right;" />';
	}

	private function remove_past_dates($resultSet){
		$result_items = array();
		$now = new DateTime('today'); // begining of the current day

		foreach($resultSet['items'] as $i){
			$date = new DateTime($i->pubDate);

			if($date >= $now) $result_items[] = $i;
		}

		$resultSet['items'] = $result_items;
		$resultSet['meta']['total'] = count($resultSet['items']);

		return $resultSet;
	}

	private function format_phone($phone){
		$phone = preg_replace('/[\D]/', '', $phone); // remove non-digit characters

		if(strlen($phone) == 10){
			$phone = preg_replace('/^(.{3})(.{3})(.{4})$/', '($1) $2-$3', $phone);

			return $phone;
		}

		return '';
	}
}
?>