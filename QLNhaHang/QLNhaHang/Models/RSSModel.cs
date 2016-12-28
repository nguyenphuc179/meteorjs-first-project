

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ServiceModel.Syndication;

using System.Xml.Linq;
using System.Text.RegularExpressions;


namespace QLNhaHang.Models
{

        public class Rss
        {
            public string Link { get; set; }
            public string Title { get; set; }
            public string Description { get; set; }
             
        }
        public class RssReader
        {
            private static string _blogURL = "http://vnexpress.net/rss/thoi-su.rss";
            public static IEnumerable<Rss> GetRssFeed()
            {
                XDocument feedXml = XDocument.Load(_blogURL);
                var feeds = from feed in feedXml.Descendants("item")
                            select new Rss
                            {
                                Title = feed.Element("title").Value,
                                Link = feed.Element("link").Value,
                                //Description = Regex.Match(feed.Element("description").Value, @"^.{1,180}\b(?<!\s)").Value
                                Description = feed.Element("description").Value
                            };
                return feeds;
            }
        }
}






 
 
  
