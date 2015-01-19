Hasten
===============
[![Gem Version](https://badge.fury.io/rb/hasten.svg)](http://badge.fury.io/rb/hasten)
[![Build Status](https://travis-ci.org/thirtysixthspan/hasten.svg?branch=master)](https://travis-ci.org/thirtysixthspan/hasten)

Overview
--------

Hasten speeds up the import of mysql dumps containing very large innodb tables with multiple indexes by setting certain mysql modes, removing all indexes from table definitions, and then altering the tables to add the indexes back once all inserts have been completed. Check out [this blog post](http://thirtysixthspan.com/posts/hasten-the-import-of-large-tables-into-mysql) for more detail.

INSTALL
-------
```
gem install hasten
```

USAGE
-----
This Ruby gem provides an executable script `hasten` that can be used as follows to import SQL files exported from mysqldump.
```
cat DUMPFILE | hasten | mysql -uUSER -pPASSWORD DATABASE
```

License
-------
Copyright (c) 2015
Derrick Parkhurst (derrick.parkhurst@gmail.com),

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

