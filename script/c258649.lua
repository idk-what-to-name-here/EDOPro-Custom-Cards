--Made by Beetron-1 Beetletop
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--return to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_BATTLE)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--gain lp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(s.lpcon)
	e2:SetTarget(s.lptg)
	e2:SetOperation(s.lpop)
	c:RegisterEffect(e2)
end
s.listed_series={0xc6}
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.perfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xba)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local atk=0
	local atk2=0
	local g1=Duel.GetMatchingGroup(s.perfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_MZONE,nil)
	if #g<=0 or #g1<=0 then return false end
	local bc=g:GetMinGroup(Card.GetAttack)
	atk=atk+bc:GetAttack()
	local bc2=g1:GetFirst()
	while bc2 do
		atk2=atk2+bc2:GetAttack()
		bc=g:GetNext()
	end
	return atk>atk2
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
