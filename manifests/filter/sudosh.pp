# A Logstash filter for the Sudo Shell (sudosh)
#
# Though this class has a great deal repeated with the other filter classes,
# they remain separate in the event that variables need to be added in the
# future for ERB processing.
#
# @param order The relative order within the configuration group. If
#   omitted, the entries will fall in alphabetical order.
#
# @param content The content that you wish to have in your filter. If
#   set, this will override *all* template contents.
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class simp_logstash::filter::sudosh (
  Integer[0]        $order   = 50,
  Optional[String]  $content = undef
){
  include '::simp_logstash'

  $_component_name = 'sudosh'
  $_group = 'filter'
  $_group_order = $::simp_logstash::config_order[$_group]

  if empty($content) {
    $_content = template("${module_name}/${_group}/${_component_name}.erb")
  }
  else {
    $_content = $content
  }

  file { "${::simp_logstash::config_prefix}-${_group_order}_${_group}-${order}-${_component_name}${::simp_logstash::config_suffix}":
    ensure  => 'file',
    owner   => 'root',
    group   => $::logstash::logstash_group,
    mode    => '0640',
    content => $_content,
    notify  => Class['logstash::service']
  }
}
