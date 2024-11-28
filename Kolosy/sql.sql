select distinct member.member_no, firstname, lastname, count(juvenile.adult_member_no)
from member
         left outer join loanhist on member.member_no = loanhist.member_no
         left join juvenile on juvenile.adult_member_no = member.member_no
where loanhist.member_no is null
group by member.member_no, firstname, lastname
order by 1