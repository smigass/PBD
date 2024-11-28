select title, title_no
from title

select title
from title
where title_no = 10

select title_no, author
from title
where author IN ('Charles Dickens', 'Jane Austen')