<?php

date_default_timezone_set('America/Los_Angeles');

error_reporting(E_ALL);
ini_set('display_errors', 1);

require_once('_core/class.dmc.php');

$newsDMC = new NewsDMC(); // optionally pass an alternate root relative path to data folder. Default is "/_resources/data/".

if (str_replace('\\', '/', strtolower(__FILE__)) == str_replace('\\', '/', strtolower($_SERVER['SCRIPT_FILENAME'])) && isset($_GET['datasource']) && $_GET['datasource'] != '') {
	get_news_dmc_output(array('endpoint' => true));
}

function get_news_dmc_output($options)
{
	global $newsDMC;
	return $newsDMC->get_output($options);
}

class NewsDMC
{

	private $dmc;
	private $defaultXPath = 'channel/item';
	private $pubDateSort = 'date(pubDate) desc'; // use asc for events
	private $defaultNewsImage = '/_resources/images/program-finder/program-filler.jpg';
	private $defautlEventsImage = '/_resources/images/program-finder/program-filler.jpg';
	private $defaultImage = array("events" => '/_resources/images/program-finder/program-filler.jpg', "news" => '/_resources/images/program-finder/program-filler.jpg');
	public function __construct($data_folder = null)
	{
		$this->dmc = new DMC($data_folder);
	}

	public function get_output($options)
	{
		if (!isset($options['xpath']) || $options['xpath'] === '') {
			$options['xpath'] = $this->defaultXPath;
		}

		$resultSet = $this->dmc->getResultSet($options);
		$sort_by_pubDate = false;
		$templating_function = '';

		switch ($resultSet['meta']['options']['type']) {
			case 'listing':
			$sort_by_pubDate = true;
			$templating_function = 'render_listing';
			break;
			case 'latest-news':
			$sort_by_pubDate = true;
			$templating_function = 'render_latest_news';
			break;
			case 'news_items':
			$sort_by_pubDate = true;
			$templating_function = 'render_news_items';
			break;
		}



		if ($sort_by_pubDate && (!isset($resultSet['meta']['options']['sort']) || $resultSet['meta']['options']['sort'] === '')) {
			$resultSet['meta']['options']['sort'] = $this->pubDateSort;
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

	public function render_latest_news($resultSet)
	{
		$output = "";

		$items = $resultSet['items'];
		$heading = $resultSet['meta']['options']['heading'];

		foreach ($items as $i) {
			$i->registerXPathNamespace('media', 'http://search.yahoo.com/mrss/');
			$href = $i->link;
			$title = $i->title;
			$image_src = isset($i->xpath('media:content/@url')[0])?$i->xpath('media:content/@url')[0]:$this->defaultImage;
			$image_alt = isset($i->xpath('media:content/media:description')[0])?$i->xpath('media:content/@url')[0]:$title;

			$output .= "
        <div class=\"latest-news__item\">
          <h3>$heading</h3>
          <div class=\"latest-news__image\">
            <img src=\"$image_src\" alt=\"$image_alt\" />
          </div>
          <a href=\"$href\">
            <p>$title</p>
          </a>
        </div>";
		}

		return $output;
	}	


	public function render_listing($resultSet)
	{
		$output = "";
		$pagination = $this->render_pagination($resultSet);

		$items = $resultSet['items'];
		$rssType = $resultSet['meta']['options']['data_type'];
		$output .= "";
		foreach ($items as $i) {
			$i->registerXPathNamespace('media', 'http://search.yahoo.com/mrss/');
			$href = $i->link;
			$date = date('F j, Y', strtotime($i->pubDate)); //e.g., September 2, 2019
			$title = $i->title;
			$description = $i->description;
			$author = $i->author;
			$categories = isset($i->category)?(array)$i->category: array();
			// $image_src = $i->children('media', true)->content->attributes()->url;
			// $image_alt = $i->children('media', true)->content->attributes()->url;
			$image_src = isset($i->xpath('media:content/@url')[0])?$i->xpath('media:content/@url')[0]:$this->defaultImage[$rssType];
			$image_alt = isset($i->xpath('media:content/media:description')[0])?$i->xpath('media:content/@url')[0]:$title;

			$output .= "
			<div class=\"news__item\">
                <div class=\"news__image\">
                  <img alt=\"$image_alt\" src=\"$image_src\">
                </div>
                <div class=\"news__body\">
                  <div class=\"news__title\">
                    <h2>
                      <a href=\"$href\">$title</a>
                    </h2>
                  </div>
                  <div class=\"news__date\">
                    $date
                  </div>
                  <div class=\"news__teaser\">
                    $description
                  </div>
                </div>
				</div>
             ";
		}
		return $output . $pagination;
	}


	private function render_pagination($resultSet){
		$result = '';

		if(!isset($resultSet['meta']['pagination'])) return $result;

		$totalPages = $resultSet['meta']['pagination']['page_count'];
		$page = $resultSet['meta']['pagination']['current_page'];

		$firstLinkedPage = $resultSet['meta']['pagination']['first_linked_page'];
		$lastLinkedPage = $resultSet['meta']['pagination']['last_linked_page'];

		if($totalPages < 2) return ''; // only return the pagination if there are more than 1 page.
		$previousPage = $page - 1;
		$nextPage = $page + 1;


		$query_string = $_SERVER['QUERY_STRING'];
		$result .= '<div class="news__pagination">';
		if($previousPage > 0){
			$result .= ' <a href="?' . $this->dmc->updateQuerystringParameter($query_string, 'page', $previousPage) . '" class="paginate_button previous disabled">Previous</a>';
		} else {
			$result .= ' <a href="?' . $this->dmc->updateQuerystringParameter($query_string, 'page', $previousPage) . '" class="paginate_button previous">Previous</a>';
		}

		$result .= '<span>';
		if($firstLinkedPage > 1){
			$result .= '<a href="?'. $this->dmc->updateQuerystringParameter($query_string, 'page', 1) .'" class="paginate_button">' . 1 . '</a>...';
		}


		for ($i = $firstLinkedPage; $i <= $lastLinkedPage; $i++) {
			if($i == $page){
				$result .= '<a href="?'. $this->dmc->updateQuerystringParameter($query_string, 'page', $i) .'" class="paginate_button current">' . $i . '</a>';
			}else{
				$result .= '<a href="?'. $this->dmc->updateQuerystringParameter($query_string, 'page', $i) .'" class="paginate_button">' . $i . '</a>';
			}
		}

		if($lastLinkedPage < $totalPages){
			$result .= '...<a href="?' . $this->dmc->updateQuerystringParameter($query_string, 'page', $totalPages) . '" class="paginate_button">'.$totalPages.'</a>';
		}

		$result .= '</span>';
		if($nextPage <= $totalPages){
			$result .= ' <a href="?' . $this->dmc->updateQuerystringParameter($query_string, 'page', $nextPage) . '" class="paginate_button next">Next</a>';    
		} else {
			$result .= ' <a href="?' . $this->dmc->updateQuerystringParameter($query_string, 'page', $nextPage) . '" class="paginate_button next disabled">Next</a>';    
		}

		$result .= '</div>';
		return $result;
	}



	private function get_featured_output($item)
	{
		$item->registerXPathNamespace('media', 'http://search.yahoo.com/mrss/');
		$href = $item->link;
		$title = $item->title;
		$description = $item->description;
		$image_src = isset($i->xpath('media:content/@url')[0])?$i->xpath('media:content/@url')[0]:$this->defaultImage;
		$image_alt = isset($i->xpath('media:content/media:description')[0])?$i->xpath('media:content/@url')[0]:$title;

		$output = "
			<div class=\"featured-article__container\">
                <div class=\"overlay__solid--blue\"></div>
                <div class=\"img__container--overflow\">
                    <img src=\"$image_src\" alt=\"$image_alt\"/>
                </div>
                <div class=\"featured-article__content\">
                    <h3>$title</h3>
                    <p>$description</p>
                </div>
                <div class=\"overlay__border--yellow\"></div>
                <a href=\"$href\" class=\"cta__button cta__button--gray\">Read More</a>
            </div>";
		return $output;
	}

	private function get_top_story_output($item, $heading)
	{
		$item->registerXPathNamespace('media', 'http://search.yahoo.com/mrss/');
		$href = $item->link;
		$title = $item->title;
		$image_src = isset($i->xpath('media:content/@url')[0])?$i->xpath('media:content/@url')[0]:$this->defaultImage;
		$image_alt = isset($i->xpath('media:content/media:description')[0])?$i->xpath('media:content/@url')[0]:$title;

		$output = "
            <article>
                <h3>$heading</h3>
                <div class=\"article__container\">
                    <div class=\"article__img--container\">
                        <img src=\"$image_src\" alt=\"$image_alt\">
                    </div>
                    <a href=\"$href\">
                      <p>$title</p>
                    </a>
                </div>
            </article>";
		return $output;
	}

	public function render_news_items($resultSet){
		$output = "";
		$items = $resultSet['items'];
		$title = $resultSet['meta']['options']['title'];
		$output .=  '	<div class="container">';
		$output .= '   <p style="font-size:28px;">'. $title . '</p>';
		$output .=  '	<div class="row">';

		foreach ($items as $i) {
			$href = $i->attributes()->href;
			$thumb = $i->xpath('media:content/media:thumbnail');
			if(!empty($thumb[0]) and !empty($thumb[0]->attributes()->url)){
				$thumbnail = (string) $thumb[0]->attributes()->url;
				$temp_alt = $i->xpath('media:content/media:title');
				$alt = (string) $temp_alt[0];
			}else{
				$thumbnail = '';
			}
			$output .=  '	<div class="col-sm-4">';
			$output .=  '	<div class="card" style="width: 18rem;">';
			if($thumbnail != ''){
				$output .=  '		<img src="'.$thumbnail.'" class="card-img-top" alt="'.$alt.'">';
			}else{
				$output .=  '		<img src=" /_resources/images/placeholder-news.jpg" class="card-img-top" alt="placeholder">';
			}
			$output .=  '		<div class="card-body">';
			$output .=  '		<p style="font-size:20px;" class="card-title">'. $i->title .'</p>';
			$output .=  '		<p class="card-text">'. $i->description .'</p>';
			$output .=  '	<a href="'. $i->link .'" class="btn btn-primary">Go To Article</a>';
			$output .=  '  </div>';
			$output .=  '</div>';
			$output .=  '</div>';
		}
		$output .=  '</div>';
		$output .=  '</div>';
		return $output;
	}
}

?>
