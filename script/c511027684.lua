--D/D Count Surveyor
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--special summon
	local params={aux.FilterBoolFunction(Card.IsSetCard,0xad)}
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(Fusion.SummonEffTG(table.unpack(params)))
	e3:SetOperation(Fusion.SummonEffOP(table.unpack(params)))
	c:RegisterEffect(e3)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(g:GetSum(Card.GetAttack))
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local c=e:GetHandler()
	--banish replace
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e14:SetCode(EFFECT_SEND_REPLACE)
	e14:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e14:SetRange(LOCATION_PZONE)
	e14:SetTarget(s.reptg)
	e14:SetValue(s.repval)
	e14:SetOperation(s.repop)
	c:RegisterEffect(e14)
end
function s.repfilter(c,tp)
	return not c:IsControler(tp) and c:GetDestination()==LOCATION_REMOVED
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	return true
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end