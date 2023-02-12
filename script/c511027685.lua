--D/D/D/D Super-Dimensional Sovereign Zero Emperor Paradox
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Cannot be normal summoned/set
	c:EnableUnsummonable()
	--special summon procedure
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--Double ATK
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.atkop)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
	aux.GlobalCheck(s,function()
		s[0]=false
		s[1]=false
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			s[0]=false
			s[1]=false
		end)
	end)
end
s.listed_series={SET_DDD}
function s.spcfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:HasLevel() and c:IsSummonPlayer(tp) and c:IsFaceup() and c:IsSetCard(SET_DDD)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(s.spcfilter,nil,tp)
	if #sg==0 then return false end
	local pg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if #pg==0 then return false end
	local total_scales=pg:GetSum(Card.GetScale)
	local total_levels=sg:GetSum(Card.GetLevel)
	return total_scales>total_levels
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(0,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,PLAYER_ALL,LOCATION_ONFIELD,c)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and  c:IsPreviousControler(tp) 
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsPreviousPosition(POS_FACEUP) and tc:IsPreviousSetCard(SET_DDD) then
			s[tc:GetPreviousControler()]=true
		end
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return s[tp]
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(c:GetAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
-------------------------------------------------------------
function s.filter(c)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_PZONE)>-1
		and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_PZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_PZONE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_PZONE,ft,ft,nil)
		for tc in aux.Next(g) do
			local loc=tc:GetLocation()
			loc=LOCATION_PZONE
				for tc in aux.Next(g) do
					if Duel.MoveToField(tc,tp,tp,loc,POS_FACEUP,true) then
						local e1=Effect.CreateEffect(tc)
						e1:SetDescription(aux.Stringid(4011,15))
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetRange(LOCATION_PZONE)
						e1:SetCountLimit(1)
						e1:SetCode(EVENT_TURN_END)
						e1:SetReset(EVENT_PHASE+PHASE_END)
						e1:SetOperation(s.stgop)
						tc:RegisterEffect(e1)
					end
				end
		end
end
function s.stgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if c then
			Duel.MoveToField(c,1-tp,1-tp,c:GetPreviousLocation(),c:GetPreviousPosition(),true,(1<<c:GetPreviousSequence()))
		end
end