$(document).ready(function() {
	// call the tablesorter plugin and add a pager
	// only sort tables with the 'tablesorter' class 
	$("table.tablesorter").tablesorter({widthFixed: false, widgets: ['zebra']})
	$("table.tablesorter").tablesorterPager({positionFixed: false, container: $("#pager")});
  });