from django.db import models
from django.contrib.postgres.fields import ArrayField
import re

# USER
class User(models.Model):
    name = models.CharField(max_length=30,unique=True,null=True)
    code = models.TextField(max_length=128)
    mode = models.CharField(max_length=5,choices=[('rules','Rule'),('sp','Safety Property')])

    def __str__(self):
        return '%s' % self.code

# CHANNEL
# name  : name of Channel
class Channel(models.Model):
    name = models.CharField(max_length=30)
    icon = models.TextField(null=True)

    def __str__(self):
        return '%s' % (self.name)

# CAPABILITY
# name          : name of capability
# channel       : parent channel of capability (FK)
# readable      : does this capability maintain a state?
# writeable     : can this capability's state be edited?
# statelabel    : text description of capability (state form)
# commandlabel  : text description of capability (action form)
# e_startlabel  : text description of capability (event form, entry into state)
# e_endlabel    : text description of capability (event form, exit from state)
class Capability(models.Model):
    name = models.CharField(max_length=30)
    channels = models.ManyToManyField(Channel)
    readable = models.BooleanField(default=True)
    writeable = models.BooleanField(default=True)
    statelabel = models.TextField(null=True,max_length=256)
    commandlabel = models.TextField(null=True,max_length=256)
    eventlabel = models.TextField(null=True,max_length=256)

    def __str__(self):
        return '%s' % (self.name)

    def update_paramname(self,old,new):
        try:
            p = Parameter.objects.get(name=old,cap_id=self.id)
        except Parameter.DoesNotExist:
            print("no such param")
            return

        l = self.statelabel
        if l != None:
            newl = re.sub(r'{%s((?:/\W{2,3}|/\w\W|).*?)}' % old,r'{%s\1}' % new,l)
            print("old:",l,"\nnew:",newl)
            self.statelabel=newl
            self.save()

        l = self.eventlabel
        if l != None:
            newl = re.sub(r'{%s((?:/\W{2,3}|/\w\W|).*?)}' % old,r'{%s\1}' % new,l)
            print("old:",l,"\nnew:",newl)
            self.eventlabel=newl
            self.save()

        l = self.commandlabel
        if l != None:
            newl = re.sub(r'{%s((?:/\W{2,3}|/\w\W|).*?)}' % old,r'{%s\1}' % new,l)
            print("old:",l,"\nnew:",newl)
            self.commandlabel = newl
            self.save()

        p.name=new
        p.save()
        return

    def prefix(self,s=True,e=True,c=True):
        if self.readable:
            if s:
                self.statelabel = "({DEVICE}) " + self.statelabel
            else:
                self.statelabel = re.sub(r'\(\{DEVICE\}\) ','',self.statelabel)

            if e:
                self.eventlabel = "({DEVICE}) " + self.eventlabel
            else:
                self.eventlabel = re.sub(r'\(\{DEVICE\}\) ','',self.eventlabel)
        if self.writeable:
            if c:
                self.commandlabel = "({DEVICE}) " + self.commandlabel
            else:
                self.commandlabel = re.sub(r'\(\{DEVICE\}\) ','',self.commandlabel)

        self.save()
        return


class Parameter(models.Model):
    name = models.TextField()
    type = models.TextField(choices=[('set',"Set"),
                                    ('range',"Range"),
                                    ('bin',"Binary"),
                                    ('color',"Color"),
                                    ('time',"Time"),
                                    ('duration',"Duration"),
                                    ('input',"Input"),
                                    ('meta',"Meta")])
    cap = models.ForeignKey(Capability,on_delete=models.CASCADE)

    def __str__(self):
        return "%s, %d" % (self.name, self.id)

# SETPARAM (Fixed-Set Parameter, represented by dropdown)
class SetParam(Parameter):
    numopts = models.IntegerField(default=0)

# SETPARAMOPT (Fixed-Set Parameter Option)
class SetParamOpt(models.Model):
    value = models.TextField()
    param = models.ForeignKey(SetParam,on_delete = models.CASCADE)
    def __str__(self):
        return "%s, %s" % (self.value, str(self.param))

# RANGEPARAM (Range-based Parameter, represented by slider)
class RangeParam(Parameter):
    min = models.IntegerField()
    max = models.IntegerField()
    interval = models.FloatField(default=1.0)

# BINPARAM (Binary Parameter, represented by binary radial options)
class BinParam(Parameter):
    tval = models.TextField()
    fval = models.TextField()

# COLORPARAM (Color Parameter, represented by color picker)
class ColorParam(Parameter):
    mode = models.TextField(choices=[('rgb',"RGB"),('hsv',"HSV"),('hex',"Hex")])

# TIMEPARAM (Time Parameter, represented by time picker)
class TimeParam(Parameter):
    mode = models.TextField(choices=[('24',"24-hour"),('12',"12-hour")])

# DURATIONPARAM (Duration Parameter, represented by 1-3 int selection boxes)
class DurationParam(Parameter):
    comp = models.BooleanField(default=False)
    maxhours = models.IntegerField(null=True,default=23)
    maxmins = models.IntegerField(null=True,default=59)
    maxsecs = models.IntegerField(null=True,default=59)

# INPUTPARAM (User-Input Parameter, represented by text boxes)
class InputParam(Parameter):
    inputtype = models.TextField(choices=[('int',"Integer"),('stxt',"Short Text"),('ltxt',"Long Text"),('trig',"Trigger")])

# METAPARAM (Trigger Parameter, represented by Trigger Selector)
class MetaParam(Parameter):
    is_event = models.BooleanField()

# PARVAL (Parameter/Value Pair, used for state-tracking & actions)
class ParVal(models.Model):
    par = models.ForeignKey(Parameter,on_delete = models.CASCADE)
    val = models.TextField()
    state = models.ForeignKey('State',on_delete = models.CASCADE)

# CONDITION (used for triggers)
# par   : triggering parameter
# val   : value to trigger
# cond  : comparator to determine if condition is true
class Condition(models.Model):
    par = models.ForeignKey(Parameter,on_delete = models.CASCADE)
    val = models.TextField()
    comp = models.TextField(choices=[('=',"is"),('!=',"is not"),('<',"is less than"),('>',"is greater than")])
    trigger = models.ForeignKey('Trigger',on_delete = models.CASCADE)

# DEVICE
# owner : user who owns device
# name  : name of device
# caps  : set of capabilities available to this device (M2M)
class Device(models.Model):
    owner = models.ForeignKey(User,on_delete = models.CASCADE)
    public = models.BooleanField(default=True)
    name = models.CharField(max_length=32)
    icon = models.TextField(null=True)
    chans = models.ManyToManyField(Channel)
    caps = models.ManyToManyField(Capability)

    def __str__(self):
        return self.name

# STATE
# cap       : parent capability of state
# dev       : parent device of state
# vals      : current set of param/val pairs (M2M)
class State(models.Model):
    cap = models.ForeignKey(Capability,on_delete = models.CASCADE)
    dev = models.ForeignKey(Device,on_delete = models.CASCADE)
    chan = models.ForeignKey(Channel,on_delete = models.CASCADE,null=True)
    action = models.BooleanField()
    text = models.TextField(max_length=128,null=True)


# TRIGGER
# cap   : 
# dev   : 
class Trigger(models.Model):
    cap = models.ForeignKey(Capability,on_delete = models.CASCADE)
    dev = models.ForeignKey(Device,on_delete = models.CASCADE)
    chan = models.ForeignKey(Channel,on_delete = models.CASCADE,null=True)
    pos = models.IntegerField(null=True)
    text = models.TextField(max_length=128,null=True)

class Rule(models.Model):
    owner = models.ForeignKey(User,on_delete = models.CASCADE)
    task = models.IntegerField(default=1)
    version = models.IntegerField(default=0)
    lastedit = models.DateTimeField(auto_now=True)
    type = models.CharField(max_length=3,choices=[('es','es'),('ss','ss')])
    
    def __str__(self):
        return 'owner: %s, task: %s, version: %s' % (self.owner, self.task, self.version)

# ESRULE (Event-State Rule)
# triggerE      : "event" that triggers rule
# triggersS     : states that must be true to trigger rule
# actionstate   : state to make true when rule is triggered
class ESRule(Rule):
    Etrigger = models.ForeignKey(Trigger,on_delete = models.CASCADE,related_name='EStriggerE')
    Striggers = models.ManyToManyField(Trigger, blank=True)
    action = models.ForeignKey(State,on_delete = models.CASCADE,related_name='ESactionstate',limit_choices_to={'action':True})

    def __str__(self):
        condition_text = [st.text for st in self.Striggers.all()]
        return '(%d) IF %s WHILE %s THEN %s' % (self.id, self.Etrigger.text, condition_text, self.action.text)

# store information of rule sets used in the user study
class UserStudyTapSet(models.Model):
    taskset = models.IntegerField(default=0)
    scenario = models.IntegerField(default=0)
    condition = models.IntegerField(default=0)
    task_id = models.IntegerField(default=0)

    disabled = models.BooleanField(default=False)
    
    def __str__(self):
        return 'taskset: %s, scenario: %s, condition: %s, task_id: %s' % \
               (self.taskset, self.scenario, self.condition, self.task_id)


# ESRULETEMPLATE
# For initializing rules for users
class ESRuleMeta(models.Model):
    rule = models.ForeignKey(ESRule, on_delete = models.CASCADE)
    tapset = models.ForeignKey(UserStudyTapSet, on_delete=models.CASCADE)
    is_template = models.BooleanField(default=False)

    def __str__(self):
        return 'owner: %s, ver: %s, rule: %s, ruleid: %s, taskset: %s, scenario: %s, condition: %s, task_id: %s' % \
               (self.rule.owner, str(self.rule.version), str(self.rule), self.rule.id, self.tapset.taskset, self.tapset.scenario, self.tapset.condition, self.tapset.task_id)

# SSRULE (State-State Rule)
# triggers      : states that must be true to trigger rule
# priority      : priority value of rule
# actionstate   : state to make true when rule is triggered
class SSRule(Rule):
    triggers = models.ManyToManyField(Trigger)
    priority = models.IntegerField()
    action = models.ForeignKey(State,on_delete = models.CASCADE,related_name='SSactionstate',limit_choices_to={'action':True})

'''
# EERULE (Event-Event Rule): No Longer in Use
# triggers      : "events" that trigger rule
# window        : number of minutes necessary
class EERule(models.Model):
    triggers = models.ManyToManyField(State)
    window = models.IntegerField()
    actionstate = models.ForeignKey(State,on_delete = models.CASCADE,related_name='EEactionstate')
'''

class SafetyProp(models.Model):
    owner = models.ForeignKey(User,on_delete = models.CASCADE)
    task = models.IntegerField()
    lastedit = models.DateTimeField(auto_now = True)
    type = models.IntegerField(choices=[(1,'1'),(2,'2'),(3,'3')])
    always = models.BooleanField()

class SP1(SafetyProp):
    triggers = models.ManyToManyField(Trigger)

class SP2(SafetyProp):
    state = models.ForeignKey(Trigger,on_delete = models.CASCADE,related_name='sp2_state')
    comp = models.TextField(choices=[('=','='),('!=','!='),('>','>'),('<','<')],null=True)
    time = models.IntegerField(null=True)
    conds = models.ManyToManyField(Trigger,related_name='sp2_conds')

class SP3(SafetyProp):
    event = models.ForeignKey(Trigger,on_delete = models.CASCADE,related_name='sp3_event')
    comp = models.TextField(choices=[('=','='),('!=','!='),('>','>'),('<','<')],null=True)
    occurrences = models.IntegerField(null=True)
    conds = models.ManyToManyField(Trigger,related_name='sp3_conds')
    time = models.IntegerField(null=True)
    timecomp = models.TextField(choices=[('=','='),('!=','!='),('>','>'),('<','<')],null=True)


# STATELOG
# timestamp     : datetime at which entry was added
# is_current    : is this the current state?
# state         : state that became active
class StateLog(models.Model):
    timestamp = models.DateTimeField(auto_now=True)
    is_current = models.BooleanField()
    cap = models.ForeignKey(Capability,on_delete = models.CASCADE,related_name='logcap')
    dev = models.ForeignKey(Device,on_delete = models.CASCADE,related_name='logdev')
    param = models.ForeignKey(Parameter,on_delete = models.CASCADE,related_name='logparam')
    value = models.TextField()


# USERSELECTION
class UserSelection(models.Model):
    owner = models.ForeignKey(User, on_delete = models.CASCADE)
    task = models.IntegerField()
    selection = ArrayField(models.IntegerField())
    time_elapsed = models.IntegerField(null=True)
