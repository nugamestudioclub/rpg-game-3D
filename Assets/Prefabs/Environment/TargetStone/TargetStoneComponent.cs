using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TargetStoneComponent : MonoBehaviour
{
    [SerializeField]
    private Animator referenceAnimator;
    [SerializeField]
    private string enableAnimationName;
    [SerializeField]
    private string disableAnimationName;
    private bool called = false;
    public bool IsCalled { get { return this.called; } }
    private bool pCalled = false;

    [SerializeField]
    public UnityEngine.Events.UnityEvent action;

    [SerializeField]
    private bool isFinal;
    private string initEnable;
    [SerializeField]
    private IntroLevelManager initator;
    [SerializeField]
    private PlayerLook cameraInit;
    
    public void Call()
    {
        
        this.called = true;
        
        
    }
   
    public void UnCall()
    {
        
        this.called = false;
       
    }

    private TargetStoneComponent c1;
    private TargetStoneComponent c2;
  
    public void Swap(TargetStoneComponent component1)
    {
        this.c1 = component1;
        this.c2 = this;
        string name1E = this.c1.enableAnimationName;
        string name1D = this.c1.disableAnimationName;
        string name2E = this.c2.enableAnimationName;
        string name2D = this.c2.disableAnimationName;
        this.c1.enableAnimationName = name2E;
        this.c1.disableAnimationName = name2D;
        this.c2.enableAnimationName = name1E;
        this.c2.disableAnimationName = name1D;
        Animator refAnim = component1.referenceAnimator;
        Animator thisAnim = this.referenceAnimator;
        this.referenceAnimator = refAnim;
        component1.referenceAnimator = thisAnim;
    }
   
    

    // Start is called before the first frame update
    void Start()
    {
        this.pCalled = called;
        this.initEnable = this.enableAnimationName;
    }

    // Update is called once per frame
    void Update()
    {
       
        if (pCalled != called)
        {
            if (pCalled)
            {
                if (referenceAnimator != null)
                {
                    this.referenceAnimator.Play(disableAnimationName);
                    print("disabling");
                }
                    
            }
            else
            {
                if (referenceAnimator != null)
                {
                    this.referenceAnimator.Play(enableAnimationName);
                    print("enabling "+enableAnimationName);
                    if (enableAnimationName == this.initEnable&&this.isFinal&&!this.cameraInit.overrideEnabled)
                    {
                        this.initator.StartEvent();
                        StartCoroutine(this.forceCamInOne());
                        
                    }
                    
                }
                    
                if (action != null)
                {
                    action.Invoke();
                }
               
            }

            pCalled = called;
        }

    }
    
    private IEnumerator forceCamInOne()
    {
        yield return new WaitForSeconds(1);
        this.cameraInit.EnableSetOveride();
    }
}
