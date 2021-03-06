## Demonstration of programmatically logging in to ASP.NET web site

This is emonstration of programmatically logging in to ASP.NET web site. This consists of three steps

1. Retrieve the login page with GET request, parse the HTML for the contents of the hidden fields. HTML parsing can be done with [TFHpple](https://github.com/topfunky/hpple).

2. Then combine these fields with the userid and password fields, and then submit a POST request.

3. When you build the request, don't forget to percent-escape the values to make sure that your request is well-formed.

This is not intended as an end-user library, but just a "simple" example of how one might create custom callouts. This is for illustrative purposes only.

See http://stackoverflow.com/questions/40728386.

Developed in Objective-C on Xcode 8.1 for iOS 10. 

## License

Copyright &copy; 2015-2016 Robert Ryan. All rights reserved.

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.

--

22 Nov 2016
