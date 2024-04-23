########################################################
# Basic syntax test for the wesql_scale_filter

create filter if not exists (
        name='test1',
        desc='test description',
        priority='999',
        status='ACTIVE'
)
with_pattern(
        plans='Delete',
        fully_qualified_table_names='wesql_scale_filter.t1',
        query_regex='',
        query_template='',
        request_ip_regex='',
        user_regex='',
        leading_comment_regex='',
        trailing_comment_regex='',
        bind_var_conds=''
)
execute(
        action='FAIL',
        action_args=''
);

select
    id,name,description,priority,status,plans,fully_qualified_table_names,query_regex,query_template,request_ip_regex,user_regex,leading_comment_regex,trailing_comment_regex,bind_var_conds,action,action_args
from
    mysql.wescale_plugin;

create table if not exists wesql_scale_filter.t1 (
                                                     id int,
                                                     name varchar(32)
);
insert into wesql_scale_filter.t1 values (1, 'a');
select * from wesql_scale_filter.t1;
delete from wesql_scale_filter.t1 where id = 1;

alter filter test1 (
        name='test2',
        desc='test description',
        priority='998',
        status='ACTIVE'
)
with_pattern(
        plans='Delete',
        fully_qualified_table_names='wesql_scale_filter.t1',
        query_regex='',
        query_template='',
        request_ip_regex='',
        user_regex='',
        leading_comment_regex='',
        trailing_comment_regex='',
        bind_var_conds=''
)
execute(
        action='FAIL',
        action_args=''
);

select
    id,name,description,priority,status,plans,fully_qualified_table_names,query_regex,query_template,request_ip_regex,user_regex,leading_comment_regex,trailing_comment_regex,bind_var_conds,action,action_args
from
    mysql.wescale_plugin;

drop filter test2;

select
    id,name,description,priority,status,plans,fully_qualified_table_names,query_regex,query_template,request_ip_regex,user_regex,leading_comment_regex,trailing_comment_regex,bind_var_conds,action,action_args
from
    mysql.wescale_plugin;

########################################################
# Test ConcurrencyControlAction

create table if not exists wesql_scale_filter.ccl_table (
                                                     id int,
                                                     name varchar(32)
);
insert into wesql_scale_filter.ccl_table values (1, 'a');
insert into wesql_scale_filter.ccl_table values (2, 'b');
insert into wesql_scale_filter.ccl_table values (3, 'c');
select * from wesql_scale_filter.ccl_table;

create filter (
        name='ccl',
        desc='test ccl',
        priority='999',
        status='ACTIVE'
)
with_pattern(
        plans='Delete',
        fully_qualified_table_names='wesql_scale_filter.ccl_table',
        query_regex='',
        query_template='',
        request_ip_regex='',
        user_regex='',
        leading_comment_regex='',
        trailing_comment_regex='',
        bind_var_conds=''
)
execute(
        action='CONCURRENCY_CONTROL',
        action_args='maxQueueSize=0; max_concurrency=0'
);
select
    id,name,description,priority,status,plans,fully_qualified_table_names,query_regex,query_template,request_ip_regex,user_regex,leading_comment_regex,trailing_comment_regex,bind_var_conds,action,action_args
from
    mysql.wescale_plugin;
select sleep(3);
select * from wesql_scale_filter.ccl_table;
delete from wesql_scale_filter.ccl_table where id = 3;
select '# expect 3 rows for the next select';
select * from wesql_scale_filter.ccl_table;

alter filter ccl (
        desc='test ccl',
        priority='999',
        status='ACTIVE'
)
with_pattern(
        plans='Delete',
        fully_qualified_table_names='wesql_scale_filter.ccl_table',
        query_regex='',
        query_template='',
        request_ip_regex='',
        user_regex='',
        leading_comment_regex='',
        trailing_comment_regex='',
        bind_var_conds=''
)
execute(
        action='CONCURRENCY_CONTROL',
        action_args='maxQueueSize=1; max_concurrency=1'
);
select
    id,name,description,priority,status,plans,fully_qualified_table_names,query_regex,query_template,request_ip_regex,user_regex,leading_comment_regex,trailing_comment_regex,bind_var_conds,action,action_args
from
    mysql.wescale_plugin;
select sleep(3);
delete from wesql_scale_filter.ccl_table where id = 3;
select '# expect 2 rows for the next select';
select * from wesql_scale_filter.ccl_table;