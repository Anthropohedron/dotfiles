#!/usr/bin/gawk -f

# Input format:
#
# The first 3 lines are RDF information lines. Any of them may be left
# blank. In order, they are the title, the channel/link, and the
# description. These lines are followed by a blank line, then lines with an
# URI followed by whitespace followed by a title for the URI. URIs cannot
# contain whitespace (which is consistent with the URI standard), but the
# description may contain any character other than a newline.
#
# Output format: RDF, duh


BEGIN {
	infoLines = 4;
	headerStr = "<?xml version=\"1.0\" encoding=\"iso-8859-1\"?>\n<rdf:RDF\n  xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n  xmlns:dc=\"http://purl.org/dc/elements/1.1/\"\n  xmlns:sy=\"http://purl.org/rss/1.0/modules/syndication/\"\n  xmlns:admin=\"http://webns.net/mvcb/\"\n  xmlns:cc=\"http://web.resource.org/cc/\"\n  xmlns=\"http://purl.org/rss/1.0/\">\n\n";
	infoStr = "<channel rdf:about=\"%s\">\n<title>%s</title>\n<link>%s</link>\n<description>%s</description>\n<dc:date>%s</dc:date>\n\n";
	liStr = "<rdf:li rdf:resource=\"%s\" />\n";
	itemStr = "<item rdf:about=\"%s\">\n<title>%s</title>\n<link>%s</link>\n</item>\n\n";
	dateStr = gensub("[0-9][0-9]$", ":&", 1, strftime("%FT%T%z"));
}

{
	gsub("<", "&lt;");
	gsub(">", "&gt;");
	gsub("&", "&amp;");
}

NR <= infoLines { info[NR] = $0; }

NR > infoLines {
	uri[NR-infoLines] = $1;
	$1 = "";
	title[NR-infoLines] = gensub(FS, "", 1);
}

END {
	count = NR-infoLines;
	printf(headerStr);
	printf(infoStr, info[2], info[1], info[2], info[3], dateStr);
	printf("<items>\n<rdf:Seq>\n");
	for (i=1;i<=count;++i) {
		if (uri[i] !~ /^#/) printf(liStr, uri[i]);
	}
	printf("</rdf:Seq>\n</items>\n\n</channel>\n\n");
	for (i=1;i<=count;++i) {
		if (uri[i] !~ /^#/) printf(itemStr, uri[i], title[i], uri[i]);
	}
	printf("</rdf:RDF>\n\n");
}
