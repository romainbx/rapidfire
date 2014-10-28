var reset_inputs = function(q, val) {
  $('*[data-question-condition='+q+']').not('[data-answer*="'+val+'"]').each(function(){
    $(this).find(":input").val("");
    $(this).find("input:checked").removeAttr("checked");
  });
}

var adapt_conditionals_fields = function(q, val) {
  $('*[data-question-condition-parents~='+q+']').css("display", "none");
  $('*[data-question-condition='+q+'][data-answer*="'+val+'"]').css("display", "block");
  reset_inputs(q, val);
}

var change_check = function(element) {
  q = element.data('question');
  val = element.val();
  if(element.is(':checked')) {
    $('*[data-question-condition='+q+'][data-answer*="'+val+'"]').css("display", "block");
  }
  else {
    $('*[data-question-condition='+q+'][data-answer*="'+val+'"]').css("display", "none");
    reset_inputs(q, val);
  }
}

$(document).ready(function(){
  $("#question_question_condition_id").change(function(){
  });

  $("select").change(function(){
    q = $(this).data('question');
    val = $(this).val();
    adapt_conditionals_fields(q, val);
  });

  $("input[type=checkbox]").change(function(){
    change_check($(this));
  });
  $("input[type=checkbox]").click(function(){
    q = $(this).data('question');
    val = $(this).val();
    if($(this).is(':checked')) {
      $('*[data-question-condition='+q+'][data-answer*="'+val+'"]').css("display", "block");
    }
    else {
      $('*[data-question-condition='+q+'][data-answer*="'+val+'"]').css("display", "none");
      reset_inputs(q, val);
    }
  });

  $("input[type=radio]").change(function(){
    q = $(this).data('question');
    val = $(this).filter(":radio:checked").val();
    adapt_conditionals_fields(q, val);
  });

  $("input[type=radio]:radio:checked, select").trigger('change');
  $("input[type=checkbox]:checked").trigger("change");
});