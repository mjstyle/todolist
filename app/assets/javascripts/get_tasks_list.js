function TaskNameUpdate(){
  $('.task_name').unbind();
  $('.task_name').click(function(e){
    el  = $(e.currentTarget)
    txt = $(el).text();
    el.removeClass('task_name');
    el.addClass('task_name_edit');
    el.unbind();
    $(el).html("<textarea class='' cols='10' name='task[task_name]' rows='2'>"+txt+"</textarea><div class='btn btn-info' style='margin-top: -40px; margin-left:10px;'>UPDATE</div>");
    id  = $(el).parent().attr('data-id')
    $(el).find('.btn.btn-info').click(function(eb){
      new_txt = $(eb.currentTarget).parent().find('textarea').val();
      token   = $("meta[name='csrf-token']").attr('content');
      data    = { authenticity_token: token, id: id, task_name: new_txt }
      $.post( '/tasks/'+id+'/update_task_text', data).done(function(resp){
        if(resp){
          $(el).html(resp.new_text);
          $(el).removeClass('task_name_edit');
          $(el).addClass('task_name');
        }
        TaskNameUpdate();
      });
    });
  });
}

function AppendTask(weekday,val,root_el){
  sd        = val.start_date.replace('T00:00:00Z','');
  d_block   = root_el.find('#tds_'+sd) ;
  d         = new Date(sd);
  wd        = weekday[d.getDay()];
  //console.log(wd);
  //console.log(d.getDay());
  if( d_block.length == 0 ){
    root_el.append("<ul id='tds_" + sd + "' class='tds_block'><div class='date_val'><b>"+ sd + "</b> " + wd +"</div><div class='date_tasks_list'></div> </ul>");
    d_block = root_el.find('#tds_'+sd);
  };

  d_block = $("#tds_"+sd+" .date_tasks_list")

  dev_name  = "<div class='dev_name'>"+val.dev_name+"</div>"
  task_name = "<div class='task_name'>"+val.task_name+"</div>"
  if(val.status == 'finished'){ checked_txt = "checked='true'"; task_finished = 1; finished_class = 'done'; }else{ checked_txt = ''; task_finished = 0; finished_class = ''; };
  checkbox  = "<input id='done_task_"+val.id+"' name='done_task["+val.id+"]' class='checkbox_done' type='checkbox' value='"+task_finished+"' "+checked_txt+">"
  d_block.append("<li id='t_" + val.id + "' data-id='"+val.id+"' data-start-date='"+sd+"' data-position='"+val.position+"' class='task ui-state-default "+finished_class+"'>" +dev_name+task_name+checkbox+"<div class='remove_item btn btn-danger'>X</div><span class='line_through'></span></li> ")
}

function GetTaskList(){

  //var greenDates = ['8-15-2013', '8-22-2013'];
  //var redDates = ['8-9-2013', '8-13-2013'];
  //function colorize(date) {
  //  mdy = date.getDate() + '-' + (date.getMonth() + 1) + '-' + date.getFullYear();
  //  console.log(mdy);
  //  if ($.inArray(mdy, blueDates) > -1) {
  //    return [true, "blue"];
  //  } else if ($.inArray(mdy, greenDates) > -1) {
  //    return [true, "green"];
  //  } else if ($.inArray(mdy, redDates) > -1) {
  //    return [true, "red"];
  //  } else {
  //    return [true, ""];
  //  }
  //
  //}

  postfix = $('form#searching_form').serialize();
  $.get('/tasks/get_tasks?'+postfix).done(function(resp){
    if( resp ){
      root_el = $('.tasks_list')
      weekday = new Array(7);
      weekday[6]=  "Sunday";
      weekday[0] = "Monday";
      weekday[1] = "Tuesday";
      weekday[2] = "Wednesday";
      weekday[3] = "Thursday";
      weekday[4] = "Friday";
      weekday[5] = "Saturday";

      $.each( resp.todays, function( index, val ) {
        AppendTask(weekday,val,root_el)
      });

      $.each( resp.tomorrows, function( index, val ) {
        AppendTask(weekday,val,root_el)
      });

      $.each( resp.tasks, function( index, val ) {
        AppendTask(weekday,val,root_el)
      });

      TaskNameUpdate();

      $('.remove_item').click(function(e){

        if(confirm('Are you sure you want to remove this task?')){
          token = $("meta[name='csrf-token']").attr('content');
          id    = $(e.currentTarget).parent().attr('data-id');
          data  = { authenticity_token: token, id: id }
          $.post( '/tasks/'+id+'/remove_task', data).done(function(resp){
            if(resp && resp.success){
              $(e.currentTarget).parent().remove();
            };
          });
        }
      });

      $('.checkbox_done').change(function(e){
        el = $(e.currentTarget);
        id = $(el).parents().attr('data-id');
        if( el.prop('checked') ){
          checked = true;
          el.parents().addClass('done');
        }else{
          checked = false;
          el.parents().removeClass('done');
        };
        token = $("meta[name='csrf-token']").attr('content');
        data  = { authenticity_token: token, id: id, checked: checked }
        $.post( '/tasks/'+id+'/update_task_done', data);

      });

      $('.tds_block .date_tasks_list').sortable({connectWith: ".date_tasks_list", stop: function( event, ui ){
        el          = ui.item;
        pos         = el.attr('data-position');
        start_date  = el.attr('data-start-date');
        id          = el.attr('data-id');
        parent_id   = $(el).parents('.tds_block').attr('id');
        parent_date = parent_id.replace('tds_','')
        if( parent_date == start_date ){ date_changed = false }else{ date_changed = true };

        token         = $("meta[name='csrf-token']").attr('content');
        data          = { authenticity_token: token, id: id }

        data['start_date'] = parent_date;

        if(date_changed){data['date_changed'] = 'true';}else{data['date_changed'] = 'false';};

        if( $(el).prev().length == 0 ){ data['new_position'] = 0 }else{ data['new_position'] = $(el).index(); }
        arr = []
        $.each( $(el).parent().find('li'), function(index, val){
          arr.push($(val).attr('data-id'));
        });
        data['today_ids'] = arr;

        $.post( '/tasks/'+id+'/update_task', data);



      } }).disableSelection();

    }else{
      $('.tasks_list').html("<b>There is no tasks</b>");
    }
  });
}